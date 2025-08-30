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


    public function create()
    {
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
        'product_photo_1' => 'required|image|max:4096',
        'product_photo_2' => 'nullable|image|max:4096',
        'product_photo_3' => 'nullable|image|max:4096',
        'product_photo_4' => 'nullable|image|max:4096',
    ]);

    // تحميل الصورة الرئيسية
    $path1 = $request->file('product_photo_1')->store('products', 'public');
    $url1 = asset('storage/' . $path1);

    // معالجة الصور الإضافية
    $url2 = null;
    $url3 = null;
    $url4 = null;

    if ($request->hasFile('product_photo_2')) {
        $path2 = $request->file('product_photo_2')->store('products', 'public');
        $url2 = asset('storage/' . $path2);
    }
    
    if ($request->hasFile('product_photo_3')) {
        $path3 = $request->file('product_photo_3')->store('products', 'public');
        $url3 = asset('storage/' . $path3);
    }
    
    if ($request->hasFile('product_photo_4')) {
        $path4 = $request->file('product_photo_4')->store('products', 'public');
        $url4 = asset('storage/' . $path4);
    }

    // التحقق من عدم وجود منتج بنفس الاسم
    if (Product::where("product_name", $validated['product_name'])->first() != null) {
        return response()->json(["message" => "This Product Already Exists"], 403);
    }

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
            'product_photo_1' => $url1, // استخدام المسار بدلاً من الملف
            'product_photo_2' => $url2,
            'product_photo_3' => $url3,
            'product_photo_4' => $url4,
        ]);

        return response()->json([
            'message' => 'تم إضافة المنتج بنجاح',
            'product' => $product
        ], 201);

    } catch (\Exception $e) {
    \Log::error('Product creation error: ' . $e->getMessage());
    \Log::error('File: ' . $e->getFile());
    \Log::error('Line: ' . $e->getLine());
    
    return response()->json([
        'message' => 'فشل في إضافة المنتج',
        'error' => $e->getMessage(),
        'trace' => $e->getTraceAsString() // فقط في وضع التطوير
    ], 500);
}
}

    public function show($id)
    {
        // عرض بيانات محددة
        $product = Product::find($id);

        if (!$product) {
            return response()->json(['message' => 'المنتج غير موجود'], 404);
        }

        return response()->json($product);
    }

    public function edit($id)
    {
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
            'product_available' => 'sometimes|in:0,1',
            'product_state' => 'sometimes|in:0,1',
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

    public function destroy($id)
    {
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