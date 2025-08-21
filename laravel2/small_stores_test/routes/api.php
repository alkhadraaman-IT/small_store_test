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

Route::controller(AuthController::class)->group(function () {
    Route::post('login', 'login');
    Route::post('register', 'register');
    Route::post('logout', 'logout')->middleware('auth:sanctum');
    Route::get('ForgotPassword', 'ForgotPassword');
    Route::post('CheckCode', 'CheckCode')->middleware('auth:sanctum');
    Route::post('ChangePassword', 'ChangePassword')->middleware('auth:sanctum');
});

Route::middleware('auth:sanctum')->group(function () {

    //المستخدم
    Route::post('/users/add', [UserController::class, 'store']);
    Route::get('/users/view', [UserController::class, 'index']); // عرض جميع المستخدمين
    Route::get('/users/view/{id}', [UserController::class, 'show']); // عرض مستخدم معين

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

    //المنتج
    Route::post('/products/add', [ProductController::class, 'store']);
    Route::get('/products/view', [ProductController::class, 'index']); // عرض جميع المتاجر
    Route::get('/products/view/{id}', [ProductController::class, 'show']); // عرض متجر معين

    //المفضلة
    Route::post('/favorite/add', [FavoriteController::class, 'store']);
    Route::get('/favorite/view', [FavoriteController::class, 'index']); // عرض جميع العناصر المفضلة
    Route::get('/favorite/view/{id}', [FavoriteController::class, 'show']); // عرض عنصر مفضلة معين


    //الإعلانات
    Route::post('/announcement/add', [AnnouncementController::class, 'store']);
    Route::get('/announcement/view', [AnnouncementController::class, 'index']); // عرض جميع الإعلانات
    Route::get('/announcement/view/{id}', [AnnouncementController::class, 'show']); // عرض إعلان معين
});