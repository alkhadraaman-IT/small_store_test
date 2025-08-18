<?php

namespace App\Http\Controllers;

use App\Models\Type;
use Illuminate\Http\Request;

class TypeController extends Controller
{
    //
    public function index() {
    // عرض قائمة
    $types = Type::all();
        return response()->json($types);
}

public function create() {
    // عرض نموذج إنشاء
}

public function store(Request $request) {
    // تخزين بيانات جديدة
}

public function show($id) {
 // عرض بيانات محددة
    $type = Type::find($id);
        
        if (!$type) {
            return response()->json(['message' => 'النوع غير موجود'], 404);
        }

        return response()->json($type);
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

public function getByClassId($class_id) {
        $types = Type::where('class_id', $class_id)->get();

        if ($types->isEmpty()) {
            return response()->json(['message' => 'لا يوجد أنواع لهذا الـ class_id'], 404);
        }

        return response()->json($types);
    }

}
