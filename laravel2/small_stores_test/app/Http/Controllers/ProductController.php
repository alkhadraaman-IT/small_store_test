<?php

namespace App\Http\Controllers;

use App\Models\Favorite;
use App\Models\Product;
use Illuminate\Http\Request;

class ProductController extends Controller
{
    //
    public function index($id)
{
    // عرض قائمة المنتجات لمتجر معين
    $products = Product::where('product_state', true)
                       ->where('store_id', $id)
                       ->get();

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

public function update(Request $request, $id)
{
    $product = Product::find($id);
    
    if (!$product) {
        return response()->json(['message' => 'المنتج غير موجود'], 404);
    }

    $validated = $request->validate([
        'product_name' => 'sometimes|string|max:255',
        'type_id' => 'sometimes|exists:types,id',
        'product_description' => 'sometimes|string',
        'product_price' => 'sometimes|integer|min:0',
        'product_available' => 'sometimes|boolean',
        'product_state' => 'sometimes|boolean',
        'product_photo_1' => 'sometimes|string',
        'product_photo_2' => 'nullable|string',
        'product_photo_3' => 'nullable|string',
        'product_photo_4' => 'nullable|string',
    ]);

    $product->update($validated);
    $product->refresh(); // لإعادة تحميل البيانات من قاعدة البيانات

    return response()->json([
        'message' => 'تم تحديث المنتج بنجاح',
        'product' => $product
    ]);
}

public function destroy($id) {
    // حذف بيانات
    try {
        $product = Product::findOrFail($id);
        
        // تأكد أن المنتج ليس معطلاً بالفعل
        if (!$product->product_state) {
            return response()->json([
                'message' => 'المنتج معطل بالفعل'
            ], 400);
        }

        $product->update(['product_state' => false]);

        return response()->json([
            'message' => 'تم تعطيل المنتج بنجاح',
            'product' => $product
        ]);

    } catch (\Illuminate\Database\Eloquent\ModelNotFoundException $e) {
        return response()->json(['message' => 'المنتج غير موجود'], 404);
    } catch (\Exception $e) {
        return response()->json([
            'message' => 'فشل في تعطيل المنتج',
            'error' => $e->getMessage()
        ], 500);
    }

}

}
