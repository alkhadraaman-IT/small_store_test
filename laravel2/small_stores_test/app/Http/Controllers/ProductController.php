<?php

namespace App\Http\Controllers;

use App\Models\Product;
use Illuminate\Http\Request;

class ProductController extends Controller
{
    //
    public function index() {
    // عرض قائمة
    $products = Product::where('product_state', true)->get();
        return response()->json($products);
}

public function create() {
    // عرض نموذج إنشاء
}

public function store(Request $request)
{
    // التحقق من صحة البيانات
    $validated = $request->validate([
        'store_id' => 'required|exists:stores,id',
        'product_name' => 'required|string|max:255',
        'type_id' => 'required|exists:types,id',
        'product_description' => 'required|string',
        'product_price' => 'required|numeric|min:0',
        'product_available' => 'sometimes|boolean',
        'product_state' => 'sometimes|boolean',
        'product_photo_1' => 'required|string', // يمكن استبدالها بتحميل ملف
        'product_photo_2' => 'nullable|string',
        'product_photo_3' => 'nullable|string',
        'product_photo_4' => 'nullable|string',
    ]);

    try {
        // إنشاء المنتج
        $product = Product::create([
            'store_id' => $validated['store_id'],
            'product_name' => $validated['product_name'],
            'type_id' => $validated['type_id'],
            'product_description' => $validated['product_description'],
            'product_price' => $validated['product_price'],
            'product_available' => $validated['product_available'] ?? true,
            'product_state' => $validated['product_state'] ?? true,
            'product_photo_1' => $validated['product_photo_1'],
            'product_photo_2' => $validated['product_photo_2'] ?? null,
            'product_photo_3' => $validated['product_photo_3'] ?? null,
            'product_photo_4' => $validated['product_photo_4'] ?? null,
        ]);

        return response()->json([
            'message' => 'تم إضافة المنتج بنجاح',
            'product' => $product
        ], 201);

    } catch (\Exception $e) {
        return response()->json([
            'message' => 'فشل في إضافة المنتج',
            'error' => $e->getMessage()
        ], 500);
    }
}

public function show($id) {
    // عرض بيانات محددة
    $product = Product::find($id);
        
        if (!$product) {
            return response()->json(['message' => 'المنتج غير موجود'], 404);
        }

        return response()->json($product);
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
