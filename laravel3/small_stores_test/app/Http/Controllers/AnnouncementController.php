<?php

namespace App\Http\Controllers;

use App\Models\Announcement;
use Illuminate\Http\Request;

class AnnouncementController extends Controller
{
    //
    public function index() {
    // عرض قائمة
    $announcementes = Announcement::where('announcement_state', true)->get();
        return response()->json($announcementes);
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
    // تحديث بيانات
}

public function destroy($id) {
    // حذف بيانات
}

}
