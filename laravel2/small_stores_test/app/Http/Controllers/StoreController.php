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
    $validated = $request->validate([
        'user_id' => 'required|exists:users,id',
        'store_name' => 'required|string|max:255',
        'store_phone' => 'required|string|max:20|unique:stores,store_phone',
        'store_place' => 'required|string',
        'class_id' => 'required|exists:store_classes,id',
        'store_description' => 'required|string',
        'store_photo' => 'required|image|max:4096', // ✅ صورة
    ]);

    try {
        // رفع صورة المتجر
        $path = $request->file('store_photo')->store('stores', 'public');
        $url = config('app.url') . '/storage/' . $path;

        $store = Store::create([
            'user_id' => $validated['user_id'],
            'store_name' => $validated['store_name'],
            'store_phone' => $validated['store_phone'],
            'store_place' => $validated['store_place'],
            'class_id' => $validated['class_id'],
            'store_description' => $validated['store_description'],
            'store_photo' => $url,
            'store_state' => true
        ]);

        return response()->json([
            'message' => 'تم إنشاء المتجر بنجاح',
            'data' => $store->load(['user', 'storeClass'])
        ], 201);

    } catch (\Exception $e) {
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

public function update(Request $request, $id)
{
    try {
        $store = Store::with(['user', 'storeClass'])->findOrFail($id);

        $validated = $request->validate([
            'store_name' => 'sometimes|string|max:255',
            'store_phone' => 'sometimes|string|unique:stores,store_phone,'.$store->id,
            'store_place' => 'sometimes|string',
            'class_id' => 'sometimes|exists:store_classes,id',
            'store_description' => 'sometimes|string',
            'store_photo' => 'sometimes|image|max:4096', // ✅ صورة
            'store_state' => 'sometimes|in:0,1'
        ]);

        // إذا بعت صورة جديدة
        if ($request->hasFile('store_photo')) {
            $path = $request->file('store_photo')->store('stores', 'public');
            $url = config('app.url') . '/storage/' . $path;
            $validated['store_photo'] = $url;
        }

        $store->update($validated);

        return response()->json([
            'success' => true,
            'message' => 'تم تحديث المتجر بنجاح',
            'data' => $store->refresh()
        ]);

    } catch (\Illuminate\Database\Eloquent\ModelNotFoundException $e) {
        return response()->json([
            'success' => false,
            'message' => 'المتجر غير موجود'
        ], 404);
    } catch (\Exception $e) {
        return response()->json([
            'success' => false,
            'message' => 'فشل في عملية التحديث',
            'error' => $e->getMessage()
        ], 500);
    }
}


public function destroy($id) {
    // حذف بيانات
    try {
        $store = Store::findOrFail($id);
        
        // التحقق إذا كان المتجر معطلاً بالفعل
        if (!$store->store_state) {
            return response()->json([
                'success' => false,
                'message' => 'المتجر معطل بالفعل'
            ], 400);
        }

        // تعطيل المتجر وجميع منتجاته تلقائياً
        \DB::transaction(function () use ($store) {
            $store->update(['store_state' => false]);
            
            // تعطيل جميع منتجات المتجر (اختياري)
            $store->products()->update(['product_state' => false]);
        });

        return response()->json([
            'success' => true,
            'message' => 'تم تعطيل المتجر بنجاح',
            'data' => $store->refresh()
        ]);

    } catch (\Illuminate\Database\Eloquent\ModelNotFoundException $e) {
        return response()->json([
            'success' => false,
            'message' => 'المتجر غير موجود'
        ], 404);
    } catch (\Exception $e) {
        return response()->json([
            'success' => false,
            'message' => 'فشل في تعطيل المتجر',
            'error' => $e->getMessage()
        ], 500);
    }
}

/**
 * عرض متاجر مستخدم معين
 *
 * @param int $userId
 * @return \Illuminate\Http\JsonResponse
 */
public function getUserStores($userId)
{
    try {
        // التحقق من وجود المستخدم
        $user = \App\Models\User::find($userId);
        
        if (!$user) {
            return response()->json([
                'success' => false,
                'message' => 'المستخدم غير موجود'
            ], 404);
        }

        // جلب المتاجر الخاصة بالمستخدم
        $stores = $user->stores()
                      ->where('store_state', true)
                      ->with(['storeClass']) // إذا كنت تريد تحميل العلاقات
                      ->get();

        return response()->json([
            'success' => true,
            'data' => $stores
        ]);

    } catch (\Exception $e) {
        return response()->json([
            'success' => false,
            'message' => 'حدث خطأ أثناء جلب المتاجر',
            'error' => $e->getMessage()
        ], 500);
    }
}
}
