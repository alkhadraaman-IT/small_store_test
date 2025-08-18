<?php

namespace App\Http\Controllers;

use App\Models\Announcement;
use App\Models\User;
use App\Models\Store;
use Illuminate\Http\Request;

class AnnouncementController extends Controller
{
    //
    public function index() {
    // عرض قائمة الإعلانات فقط إذا كان المتجر مفعل
    $announcements = Announcement::where('announcement_state', true)
        ->whereHas('store', function($query) {
            $query->where('store_state', '!=', 0);
        })
        ->get();

    return response()->json([
        'success' => true,
        'data' => $announcements
    ]);
}

public function create() {
    // عرض نموذج إنشاء
}

public function store(Request $request)
{
    // 1. التحقق من صحة البيانات
    $validated = $request->validate([
        'store_id' => 'required|exists:stores,id',
        'announcement_description' => 'required|string|max:1000',
        'announcement_date' => 'required|date|after_or_equal:today',
        'announcement_photo' => 'required|string', // أو 'image|mimes:jpeg,png,jpg|max:2048'
    ]);

    try {
        // 2. إنشاء الإعلان
        $announcement = Announcement::create([
            'store_id' => $validated['store_id'],
            'announcement_description' => $validated['announcement_description'],
            'announcement_date' => $validated['announcement_date'],
            'announcement_photo' => $validated['announcement_photo'],
            'announcement_state' => true // القيمة الافتراضية
        ]);

        // 3. إرجاع الاستجابة
        return response()->json([
            'message' => 'تم إضافة الإعلان بنجاح',
            'data' => $announcement->load('store') // تحميل علاقة المتجر
        ], 201);

    } catch (\Exception $e) {
        // 4. معالجة الأخطاء
        return response()->json([
            'message' => 'فشل في إضافة الإعلان',
            'error' => $e->getMessage()
        ], 500);
    }
}

public function show($id) {
    // عرض بيانات محددة
    $announcement = Announcement::find($id);
        
        if (!$announcement) {
            return response()->json(['message' => 'الإعلان غير موجود'], 404);
        }

        return response()->json($announcement);
}

public function edit($id) {
    // عرض نموذج تعديل
}

public function update(Request $request, $id) {
    // 1. البحث عن الإعلان
    $announcement = Announcement::find($id);
    if (!$announcement) {
        return response()->json(['message' => 'الإعلان غير موجود'], 404);
    }

    // 2. التحقق من صحة البيانات
    $validated = $request->validate([
        'store_id' => 'required|exists:stores,id',
        'announcement_description' => 'required|string|max:1000',
        'announcement_date' => 'required|date|after_or_equal:today',
        'announcement_photo' => 'required|string',
        'announcement_state' => 'required|boolean',
    ]);

    try {
        // 3. تحديث الإعلان
        $announcement->update($validated);

        // 4. إرجاع الاستجابة
        return response()->json([
            'message' => 'تم تحديث الإعلان بنجاح',
            'data' => $announcement->load('store')
        ], 200);

    } catch (\Exception $e) {
        return response()->json([
            'message' => 'فشل في تحديث الإعلان',
            'error' => $e->getMessage()
        ], 500);
    }
}


public function destroy($id) {
    // حذف بيانات
    $announcement = Announcement::find($id);
        if (!$announcement) {
            return response()->json(['message' => 'الإعلان غير موجود'], 404);
        }

        $announcement->announcement_state = false;
        $announcement->save();

        return response()->json([
            'message' => 'تم إيقاف الإعلان بنجاح',
            'data' => $announcement
        ]);
}

public function getUserAnnouncements($id) {
    $user = User::find($id);
    if (!$user) {
        return response()->json(['message' => 'المستخدم غير موجود'], 404);
    }

    // جلب جميع الـIDs للمتاجر التابعة للمستخدم
    $storeIds = $user->stores()->pluck('id');

    // جلب الإعلانات التي تنتمي لهذه المتاجر فقط إذا كان المتجر مفعل
    $announcements = Announcement::whereIn('store_id', $storeIds)
        ->whereHas('store', function($query) {
            $query->where('store_state', '!=', 0);
        })
        ->where('announcement_state', true)
        ->get();

    return response()->json([
        'success' => true,
        'data' => $announcements
    ]);
}

}