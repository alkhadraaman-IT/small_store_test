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

public function update(Request $request, $id) {
    // تحديث بيانات
}

public function destroy($id) {
    // حذف بيانات
}

}
