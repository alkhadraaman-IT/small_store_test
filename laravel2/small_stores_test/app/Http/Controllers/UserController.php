<?php

namespace App\Http\Controllers;

use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash; // ✅ الطريقة الصحيحةuse App\Models\User;

class UserController extends Controller
{
    //
    //
    public function index() {
    // عرض قائمة
    $users = User::where('status', true)->get();
        return response()->json($users);
}

public function create() {
    // عرض نموذج إنشاء
}

public function store(Request $request)
{
    // ✅ التحقق من البيانات
    $request->validate([
        'name' => 'required|string',
        'email' => 'required|email|unique:users',
        'phone' => 'required|numeric|unique:users',
        'password' => 'required|string|min:6',
        'profile_photo' => 'nullable|string',
        'type' => 'required|boolean',
        'status' => 'required|boolean',
    ]);

    // ✅ إنشاء المستخدم
    $user = User::create([
        'name' => $request->name,
        'email' => $request->email,
        'phone' => $request->phone,
        'password' => Hash::make($request->password),
        'profile_photo' => $request->profile_photo,
        'type' => $request->type,
        'status' => $request->status,
    ]);

    return response()->json([
        'message' => 'تم إنشاء المستخدم بنجاح',
        'user' => $user
    ], 201);
}

public function show($id) {
    // عرض بيانات محددة
    $user = User::find($id);
        
        if (!$user) {
            return response()->json(['message' => 'المستخدم غير موجود'], 404);
        }

        return response()->json($user);
    
}

public function edit($id) {
    // عرض نموذج تعديل
}

public function update(Request $request, $id)
{
    try {
        // البحث عن المستخدم
        $user = User::findOrFail($id);

        // التحقق من صحة البيانات
        $validated = $request->validate([
            'name' => 'sometimes|string|max:255',
            'email' => 'sometimes|email|unique:users,email,' . $user->id,
            'phone' => 'sometimes|numeric|unique:users,phone,' . $user->id,
            'password' => 'sometimes|string|min:8',
            'profile_photo' => 'nullable|image|mimes:jpg,jpeg,png|max:2048',
            'type' => 'sometimes|in:0,1',
            'status' => 'sometimes|in:0,1',
        ]);

        // إذا أرسل صورة
        if ($request->hasFile('profile_photo')) {
            $image = $request->file('profile_photo');

            // اسم مميز للصورة
            $imageName = time() . '_' . uniqid() . '.' . $image->getClientOriginalExtension();

            // حفظ الصورة في مجلد users داخل storage/app/public
            $path = $image->storeAs('users', $imageName, 'public');

            // حفظ المسار في قاعدة البيانات
            $validated['profile_photo'] = 'storage/' . $path;
        }

        // تحديث كلمة المرور إذا موجودة
        if (isset($validated['password'])) {
            $validated['password'] = Hash::make($validated['password']);
        }

        // تحديث المستخدم
        $user->update($validated);

        return response()->json([
            'message' => 'تم تحديث بيانات المستخدم بنجاح',
            'user' => $user
        ]);

    } catch (\Illuminate\Database\Eloquent\ModelNotFoundException $e) {
        return response()->json(['message' => 'المستخدم غير موجود'], 404);
    } catch (\Exception $e) {
        return response()->json([
            'message' => 'فشل في تحديث البيانات',
            'error' => $e->getMessage()
        ], 500);
    }
}



public function destroy($id)
{
    try {
        $user = User::findOrFail($id);
        
        // فقط تغيير حالة status إلى false دون حذف
        $user->update([
            'status' => false
        ]);
        
        return response()->json([
            'message' => 'تم تعطيل المستخدم بنجاح',
            'user' => $user
        ]);
        
    } catch (\Illuminate\Database\Eloquent\ModelNotFoundException $e) {
        return response()->json(['message' => 'المستخدم غير موجود'], 404);
    } catch (\Exception $e) {
        return response()->json([
            'message' => 'فشل في تعطيل المستخدم',
            'error' => $e->getMessage()
        ], 500);
    }
}
}
