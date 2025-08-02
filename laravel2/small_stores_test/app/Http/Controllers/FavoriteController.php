<?php

namespace App\Http\Controllers;

use App\Models\Favorite; 
use Illuminate\Http\Request;

class FavoriteController extends Controller
{
    //
    public function index() {
    // عرض قائمة
}

public function create() {
    // عرض نموذج إنشاء
}

public function store(Request $request)
{
    //تخزين البيانات
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
}

}
