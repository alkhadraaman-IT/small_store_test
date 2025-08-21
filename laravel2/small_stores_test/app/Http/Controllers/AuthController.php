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

            DB::table('verify_codes')->where('email', $email)->delete();
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
            $data = $request->validated();
            $ip = $request->ip();
            $id = Auth::user()->id;
            $email = User::find($id)->email;
            $code = verifyCode::where('email', $email)->first();
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
            return response()->json("an error occured " . $th, $th->getCode());
        }
    }

    public function ChangePassword(ChangePasswordRequest $request)
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
    }
}