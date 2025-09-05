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
    // 1. التحقق من صحة البيانات مع استقبال ملف
    $validated = $request->validate([
        'store_id' => 'required|exists:stores,id',
        'announcement_description' => 'required|string|max:1000',
        'announcement_date' => 'required|date|after_or_equal:today',
        'announcement_photo' => 'required|image|mimes:jpeg,png,jpg|max:2048', // ملف صورة
    ]);

    try {
        // 2. رفع الصورة
        if ($request->hasFile('announcement_photo')) {
            $path = $request->file('announcement_photo')->store('announcements', 'public'); 
            $validated['announcement_photo'] = '/storage/' . $path; // رابط للوصول للصورة
        }

        // 3. إنشاء الإعلان
        $announcement = Announcement::create([
            'store_id' => $validated['store_id'],
            'announcement_description' => $validated['announcement_description'],
            'announcement_date' => $validated['announcement_date'],
            'announcement_photo' => $validated['announcement_photo'],
            'announcement_state' => true
        ]);

        return response()->json([
            'message' => 'تم إضافة الإعلان بنجاح',
            'data' => $announcement->load('store')
        ], 201);

    } catch (\Exception $e) {
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

public function update(Request $request, $id)
{
    $announcement = Announcement::find($id);
    if (!$announcement) {
        return response()->json(['message' => 'الإعلان غير موجود'], 404);
    }

    $validated = $request->validate([
        'store_id' => 'required|exists:stores,id',
        'announcement_description' => 'required|string|max:1000',
        'announcement_date' => 'required|date|after_or_equal:today',
        'announcement_photo' => 'nullable|image|mimes:jpeg,png,jpg|max:2048', // يمكن تركها فارغة
        'announcement_state' => 'required|boolean',
    ]);

    try {
        // رفع الصورة إذا تم إرسالها
        if ($request->hasFile('announcement_photo')) {
            $path = $request->file('announcement_photo')->store('announcements', 'public'); 
            $validated['announcement_photo'] = '/storage/' . $path;
        }

        // تحديث الإعلان
        $announcement->update($validated);

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