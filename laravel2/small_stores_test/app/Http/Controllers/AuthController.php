<?php

namespace App\Http\Controllers;

use App\Http\Requests\Auth\ChangePasswordRequest;
use App\Http\Requests\Auth\ForgetPasswordCodeRequest;
use App\Mail\ResetPasswordMail;
use App\Models\User;
use App\Models\verifyCode;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Mail;
use Illuminate\Support\Facades\Validator;
use Illuminate\Support\Facades\Log;

class AuthController extends Controller
{
    /**
     * تسجيل مستخدم جديد
     */
    public function register(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'name' => 'required|string|max:255',
            'email' => 'required|string|email|max:255|unique:users',
            'phone' => 'required|string|unique:users',
            'password' => 'required|string|min:8',
        ]);

        if ($validator->fails()) {
            return response()->json($validator->errors(), 422);
        }

        $user = User::create([
            'name' => $request->name,
            'email' => $request->email,
            'phone' => $request->phone,
            'password' => Hash::make($request->password),
        ]);

        $token = $user->createToken('auth_token')->plainTextToken;

        return response()->json([
            'message' => 'User registered successfully',
            'user' => $user,
            'access_token' => $token,
            'token_type' => 'Bearer',
        ]);
    }

    /**
     * تسجيل الدخول
     */
    public function login(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'email' => 'required|string|email',
            'password' => 'required|string',
        ]);

        if ($validator->fails()) {
            return response()->json($validator->errors(), 422);
        }

        // محاولة التحقق من بيانات الدخول
        if (!Auth::attempt($request->only('email', 'password'))) {
            return response()->json([
                'message' => 'Invalid login details'
            ], 401);
        }

        // جلب المستخدم
        $user = User::where('email', $request->email)->firstOrFail();

        // ✅ التحقق إذا كان الحساب محظور
        if ($user->status == 0) {
            return response()->json([
                'message' => 'تم حظر هذا الحساب، الرجاء التواصل مع الإدارة.',
            ], 403); // 403 Forbidden
        }

        // إصدار التوكن إذا كل شي تمام
        $token = $user->createToken('auth_token')->plainTextToken;

        return response()->json([
            'message' => 'Login successful',
            'access_token' => $token,
            'token_type' => 'Bearer',
            'user' => $user,
        ]);
    }

    /**
     * تسجيل الخروج
     */
    public function logout(Request $request)
    {
        $request->user()->currentAccessToken()->delete();

        return response()->json([
            'message' => 'Successfully logged out'
        ]);
    }

    /**
     * معلومات المستخدم الحالي
     */
    public function me(Request $request)
    {
        return response()->json($request->user());
    }


    public function ForgotPassword(Request $request)
    {
        try {
            $validator = Validator::make($request->all(), [
                'email' => 'required|string|email',
            ]);
            if ($validator->fails()) {
                return response()->json($validator->errors(), 422);
            }
            $email = $request->email;

if (DB::table('verify_codes')->where('email', $email)->first() != null) {
                DB::table('verify_codes')->where('email', $email)->delete();
  }
            $code_v = mt_rand(10000, 99999);
            DB::table('verify_codes')->insert([
                'email' => $email,
                'code' => $code_v,
            ]);
            Mail::to($email)->send(new ResetPasswordMail($code_v));
            return response()->json(["data" => $email, 'message' => "Email sent Successfully"], 200);
        } catch (\Throwable $th) {
            return response()->json("an error occured " . $th, 500);
        }
    }

    public function CheckCode(ForgetPasswordCodeRequest $request)
    {
        try {
Log::info($request->all());
            $data = $request->validated();
            $ip = $request->ip();
           // $id = Auth::user()->id;
            //$email = User::find($id)->email;
            if (!isset($data['email'])) {
            return response()->json([
                'message' => 'البريد الإلكتروني مطلوب'
            ], 422);
        }
        $email = $data['email']; // تأكد أن الحقل اسمه 'email' في الطلب

            $code = verifyCode::where('email', $email)->first();

            if (!$code) {
            return response()->json(["message" => "لم يتم إرسال أي كود إلى هذا البريد"], 404);
        }

        if ($code['code'] != $data['code']) {
                $message = 'code not correct';
                return response()->json(["message" => $message], 401);
            }
            
            $code->update([
                'checked' => true,
                'ip' => $ip
            ]);

            return response()->json(["data" => $data, "message" => "code is correct"], 200);
        } catch (\Throwable $th) {
        return response()->json([
            'message' => 'حدث خطأ في الخادم',
            'error' => $th->getMessage() // اختياري
        ], 500);
        }
    }
public function ChangePassword(ChangePasswordRequest $request)
{
    try {
        // التحقق من أن البريد الإلكتروني موجود في الطلب
        if (!isset($request->email)) {
            return response()->json(["message" => "Email is required"], 422);
        }

        // التحقق من وجود المستخدم
        $user = User::where('email', $request->email)->first();
        if (!$user) {
            return response()->json(["message" => "User not found"], 404);
        }

        // التحقق من الكود
        $data = $request->validated();
        $ip = $request->ip();

        $code = verifyCode::where('email', $user['email'])->first();
        if (!$code) {
            return response()->json(["message" => "Verification code not found"], 404);
        }

        if ($code['ip'] != $ip || $code['checked'] == false) {
            return response()->json(["message" => "An error occurred, try later"], 401);
        }

        // التحقق من تطابق كلمات المرور
        if ($data['passwordRet'] != $data['password']) {
            return response()->json(["message" => "Passwords do not match"], 401);
        }

        // تحديث كلمة المرور
        $user->update(['password' => Hash::make($data['password'])]);
        DB::table('verify_codes')->where('email', $user['email'])->delete();

        return response()->json(["data" => $data, "message" => "Password was changed successfully"], 200);
    } catch (\Throwable $th) {
        $statusCode = $th->getCode() >= 100 && $th->getCode() <= 599 ? $th->getCode() : 500;
        return response()->json([
            "message" => "An error occurred: " . $th->getMessage(),
            "error" => $th->getMessage()
        ], $statusCode);
    }
}
    /*public function ChangePassword(ChangePasswordRequest $request)
    {

        try {
            $data = $request->validated();
            $id = Auth::user()->id;
            $ip = $request->ip();

            $user = User::find($id);

            $code = verifyCode::where('email', $user['email'])->first();
            if ($code['ip'] != $ip || $code['checked'] == false) {
                $message = 'an eror occurred try later';
                return response()->json(["message" => $message], 401);
            } elseif ($data['passwordRet'] != $data['password']) {
                $message = 'passwords do not match';
                return response()->json(["message" => $message], 401);
            }
            $user->update(['password' => Hash::make($data['password'])]);
            DB::table('verify_codes')->where('email', $user['email'])->delete();
            return response()->json(["data" => $data, "message" => "password was changed successfully"]);
        } catch (\Throwable $th) {
            return response()->json("an error occured " . $th, $th->getCode());
        }
    }*/
}