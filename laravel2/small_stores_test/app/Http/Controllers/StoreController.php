<?php

namespace App\Http\Controllers;

use App\Models\Store;
use Illuminate\Http\Request;

class StoreController extends Controller
{
    //
    public function index() {
    // عرض قائمة
    $stores = Store::where('store_state', true)->get();
        return response()->json($stores);
}

public function create() {
    // عرض نموذج إنشاء
}

public function store(Request $request)
{
    // 1. التحقق من صحة البيانات
    $validated = $request->validate([
        'user_id' => 'required|exists:users,id',
        'store_name' => 'required|string|max:255',
        'store_phone' => 'required|string|max:20',
        'store_place' => 'required|string',
        'class_id' => 'required|exists:store_classes,id',
        'store_description' => 'required|string',
        'store_photo' => 'required|string', // أو 'image|mimes:jpeg,png,jpg|max:2048' لرفع ملف
    ]);

    try {
        // 2. إنشاء المتجر
        $store = Store::create([
            'user_id' => $validated['user_id'],
            'store_name' => $validated['store_name'],
            'store_phone' => $validated['store_phone'],
            'store_place' => $validated['store_place'],
            'class_id' => $validated['class_id'],
            'store_description' => $validated['store_description'],
            'store_photo' => $validated['store_photo'], // أو حفظ الصورة إذا كانت ملفًا
            'store_state' => true // القيمة الافتراضية
        ]);

        // 3. إرجاع الاستجابة
        return response()->json([
            'message' => 'تم إنشاء المتجر بنجاح',
            'data' => $store->load(['user', 'storeClass']) // تحميل العلاقات
        ], 201);

    } catch (\Exception $e) {
        // 4. معالجة الأخطاء
        return response()->json([
            'message' => 'فشل في إنشاء المتجر',
            'error' => $e->getMessage()
        ], 500);
    }
}

public function show($id) {
    // عرض بيانات محددة
    $store = Store::find($id);
        
        if (!$store) {
            return response()->json(['message' => 'المتجر غير موجود'], 404);
        }

        return response()->json($store);
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
