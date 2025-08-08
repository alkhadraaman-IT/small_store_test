<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\UserController;
use App\Http\Controllers\TypeController;
use App\Http\Controllers\StoreClassController;
use App\Http\Controllers\StoreController;
use App\Http\Controllers\ProductController;
use App\Http\Controllers\FavoriteController;
use App\Http\Controllers\AnnouncementController;
use App\Http\Controllers\AuthController;

//تجربة الاتصال
Route::get('/ping', function () {
    return response()->json(['message' => 'API شغالة تمام']);
});

//المصادقة
Route::middleware('auth:sanctum')->get('/user', function (Request $request) {
    return $request->user();
});

Route::post('/register', [AuthController::class, 'register']);
Route::post('/login', [AuthController::class, 'login']);
Route::post('/logout', [AuthController::class, 'logout'])->middleware('auth:sanctum');
Route::get('/me', [AuthController::class, 'me'])->middleware('auth:sanctum');

//المستخدم
Route::post('/users/add', [UserController::class, 'store']);
Route::get('/users/view', [UserController::class, 'index']); // عرض جميع المستخدمين
Route::get('/users/view/{id}', [UserController::class, 'show']); // عرض مستخدم معين
Route::patch('/users/update/{id}', [UserController::class, 'update']); // عرض مستخدم معين
Route::patch('/users/delete/{id}', [UserController::class, 'destroy']); // عرض متحر معين

//الأنواع
Route::get('/types/view', [TypeController::class, 'index']); // عرض جميع الأنواع
Route::get('/types/view/{id}', [TypeController::class, 'show']); // عرض نوع معين

//الأصناف
Route::get('/classes/view', [StoreClassController::class, 'index']); // عرض جميع الأصناف
Route::get('/classes/view/{id}', [StoreClassController::class, 'show']); // عرض صنف معين

//المتجر
Route::post('/stores/add', [StoreController::class, 'store']);
Route::get('/stores/view', [StoreController::class, 'index']); // عرض جميع المتاجر
Route::get('/stores/view/{id}', [StoreController::class, 'show']); // عرض متجر معين
Route::patch('/stores/update/{id}', [StoreController::class, 'update']); // عرض متحر معين
Route::patch('/stores/delete/{id}', [StoreController::class, 'destroy']); // عرض متحر معين
Route::get('/stores/view/user/{id}', [StoreController::class, 'getUserStores']); // عرض متجر معين

//المنتج
Route::post('/products/add', [ProductController::class, 'store']);
Route::get('/products/view/stores/{id}', [ProductController::class, 'index']); // عرض جميع المتاجر
Route::get('/products/view/{id}', [ProductController::class, 'show']); // عرض متجر معين
Route::patch('/products/update/{id}', [ProductController::class, 'update']); // عرض منتج معين
Route::patch('/products/delete/{id}', [ProductController::class, 'destroy']); // عرض متحر معين

//المفضلة
Route::post('/favorite/add', [FavoriteController::class, 'store']);
Route::get('/favorite/view/user/{id}', [FavoriteController::class, 'index']); // عرض جميع العناصر المفضلة
Route::get('/favorite/view/{id}', [FavoriteController::class, 'show']); // عرض عنصر مفضلة معين
Route::patch('/favorite/delete/{id}', [FavoriteController::class, 'destroy']); // عرض متحر معين
Route::patch('/favorite/count/{id}', [FavoriteController::class, 'getProductLikesCount']); // عرض متحر معين

//الإعلانات
Route::post('/announcement/add', [AnnouncementController::class, 'store']);
Route::get('/announcement/view', [AnnouncementController::class, 'index']); // عرض جميع الإعلانات
Route::get('/announcement/view/{id}', [AnnouncementController::class, 'show']); // عرض إعلان معين


