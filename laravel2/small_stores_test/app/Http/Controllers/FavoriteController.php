<?php

namespace App\Http\Controllers;

use App\Models\User; 
use App\Models\Product;  
use App\Models\Favorite;
use Illuminate\Http\Request;

class FavoriteController extends Controller
{
    //
    /**
 * عرض المنتجات المفضلة لمستخدم معين
 * 
 * @param int $user_id
 * @return \Illuminate\Http\JsonResponse
 */
public function index($user_id)
{
    try {
        $favorites = Favorite::where('user_id', $user_id)
            ->where('state', true)
            ->orderByDesc('created_at')
            ->get(['id', 'user_id', 'product_id', 'state']);

        // تأكد أن الإرجاع دائماً يكون array حتى لو فارغ
        return response()->json([
            'success' => true,
            'data' => $favorites->toArray() // تحويل إلى array صريح
        ]);

    } catch (\Exception $e) {
        return response()->json([
            'success' => false,
            'message' => 'حدث خطأ في جلب البيانات',
            'error' => $e->getMessage()
        ], 500);
    }

    /*
    عرض مع بيانات المنتج
    try {
        // التحقق من وجود المستخدم
        $user = User::select('id', 'name')->findOrFail($user_id);

        // جلب المنتجات المفضلة النشطة مع تفاصيل المنتج
        $favorites = Favorite::with(['product' => function($query) {
                $query->select('id', 'product_name', 'product_price', 'product_photo_1')
                      ->where('product_state', true)
                      ->with(['store:id,store_name']);
            }])
            ->where('user_id', $user_id)
            ->where('state', true)
            ->orderByDesc('created_at')
            ->get(['id', 'product_id', 'created_at']);

        // تنسيق الاستجابة
        $formattedFavorites = $favorites->map(function($favorite) {
            return [
                'favorite_id' => $favorite->id,
                'product' => $favorite->product,
                'store' => $favorite->product->store,
                'added_at' => $favorite->created_at->format('Y-m-d H:i')
            ];
        });

        return response()->json([
            'success' => true,
            'user' => [
                'id' => $user->id,
                'name' => $user->name
            ],
            'favorites_count' => $favorites->count(),
            'favorites' => $formattedFavorites
        ]);

    } catch (\Illuminate\Database\Eloquent\ModelNotFoundException $e) {
        return response()->json([
            'success' => false,
            'message' => 'المستخدم غير موجود'
        ], 404);
    } catch (\Exception $e) {
        return response()->json([
            'success' => false,
            'message' => 'حدث خطأ في الخادم',
            'error' => $e->getMessage()
        ], 500);
    }*/
}

public function create() {
    // عرض نموذج إنشاء
}

public function store(Request $request)
{
    //تخزين البيانات
    $validated = $request->validate([
        'user_id' => [
            'required',
            'exists:users,id',
            function ($attribute, $value, $fail) {
                // تحقق أن المستخدم المفعل
                $user = User::find($value);
                if (!$user || !$user->status) {
                    $fail('المستخدم غير مفعل أو غير موجود');
                }
            }
        ],
        'product_id' => [
            'required',
            'exists:products,id',
            function ($attribute, $value, $fail) use ($request) {
                $product = Product::find($value);
                // تحقق أن المنتج مفعل ومتاح
                if (!$product || !$product->product_state || !$product->product_available) {
                    $fail('المنتج غير متاح للإضافة');
                }
                // تحقق أن المتجر مفعل
                if ($product->store && !$product->store->store_state) {
                    $fail('متجر المنتج غير مفعل');
                }
            }
        ]
    ]);

    try {
        // التحقق من التكرار أولاً
        $existing = Favorite::where([
            'user_id' => $validated['user_id'],
            'product_id' => $validated['product_id']
        ])->exists();

        if ($existing) {
            return response()->json([
                'success' => false,
                'message' => 'المنتج مضاف مسبقاً إلى المفضلة'
            ], 409);
        }

        $favorite = Favorite::create([
            'user_id' => $validated['user_id'],
            'product_id' => $validated['product_id'],
            'state' => true
        ]);

        return response()->json([
            'success' => true,
            'message' => 'تمت الإضافة بنجاح',
            'data' => [
                'favorite_id' => $favorite->id,
                'user' => [
                    'id' => $favorite->user_id,
                    'name' => $favorite->user->name
                ],
                'product' => [
                    'id' => $favorite->product_id,
                    'name' => $favorite->product->product_name,
                    'price' => $favorite->product->product_price
                ]
            ]
        ], 201);

    } catch (\Exception $e) {
        return response()->json([
            'success' => false,
            'message' => 'حدث خطأ أثناء الإضافة',
            'error' => $e->getMessage()
        ], 500);
    }
}

public function show($id) {
    // عرض بيانات محددة
}

public function edit($id) {
    // عرض نموذج تعديل
}

public function update(Request $request, $id) {
    // تحديث بيانات
}

public function destroy($id) {
    // حذف بيانات
    try {
            $favorite = Favorite::findOrFail($id);
            
            if (!$favorite->state) {
                return response()->json([
                    'success' => false,
                    'message' => 'العنصر معطل بالفعل'
                ], 400);
            }

            $favorite->update(['state' => false]);

            return response()->json([
                'success' => true,
                'message' => 'تم تعطيل العنصر المفضل بنجاح',
                'data' => $favorite
            ]);

        } catch (\Illuminate\Database\Eloquent\ModelNotFoundException $e) {
            return response()->json([
                'success' => false,
                'message' => 'العنصر غير موجود'
            ], 404);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'فشل في التعطيل',
                'error' => $e->getMessage()
            ], 500);
        }
}


public function getProductLikesCount($product_id)
{
    try {
        // التحقق من وجود المنتج
        Product::findOrFail($product_id);

        // حساب التفضيلات النشطة للمنتج
        $likesCount = Favorite::where([
            'product_id' => $product_id,
            'state' => true
        ])->count();

        return response()->json([
            'success' => true,
            'product_id' => $product_id,
            'likes_count' => $likesCount
        ]);

    } catch (\Illuminate\Database\Eloquent\ModelNotFoundException $e) {
        return response()->json([
            'success' => false,
            'message' => 'المنتج غير موجود'
        ], 404);
    } catch (\Exception $e) {
        return response()->json([
            'success' => false,
            'message' => 'حدث خطأ في الخادم',
            'error' => $e->getMessage()
        ], 500);
    }
}

}
