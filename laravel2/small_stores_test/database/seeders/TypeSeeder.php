<?php

namespace Database\Seeders;

use App\Models\Type;

use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;

class TypeSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        //
        Type::create([
            'class_id' => '1',
            'type_name' => 'تخرج',
        ]);//1
        Type::create([
            'class_id' => '1',
            'type_name' => 'ذكرى ولادة',
        ]);//2
        Type::create([
            'class_id' => '1',
            'type_name' => 'قدوم مولود',
        ]);//3
        Type::create([
            'class_id' => '1',
            'type_name' => 'أعياد',
        ]);//4
        Type::create([
            'class_id' => '1',
            'type_name' => 'غير ذلك',
        ]);//5
        Type::create([
            'class_id' => '2',
            'type_name' => 'تصميم',
        ]);//6
        Type::create([
            'class_id' => '2',
            'type_name' => 'برمجة مواقع',
        ]);//7
        Type::create([
            'class_id' => '2',
            'type_name' => 'برمجة تطبيقات',
        ]);//8
        Type::create([
            'class_id' => '2',
            'type_name' => 'غير ذلك',
        ]);//9
        Type::create([
            'class_id' => '3',
            'type_name' => 'ملابس أطفال',
        ]);//10
        Type::create([
            'class_id' => '3',
            'type_name' => 'ملابس رجال',
        ]);//11
        Type::create([
            'class_id' => '3',
            'type_name' => 'ملابس نشاء',
        ]);//12
        Type::create([
            'class_id' => '3',
            'type_name' => 'ملابس رضع ',
        ]);//13
        Type::create([
            'class_id' => '3',
            'type_name' => 'غير ذلك',
        ]);//14
        Type::create([
            'class_id' => '4',
            'type_name' => ' صابون',
        ]);//15
        Type::create([
            'class_id' => '4',
            'type_name' => 'عطور',
        ]);//16
        Type::create([
            'class_id' => '4',
            'type_name' => ' عناية بالبشرة',
        ]);//17
        Type::create([
            'class_id' => '5',
            'type_name' => 'صوف',
        ]);//18
        Type::create([
            'class_id' => '5',
            'type_name' => 'غير ذلك',
        ]);//19
        Type::create([
            'class_id' => '6',
            'type_name' => 'عصائر',
        ]);//20
        Type::create([
            'class_id' => '6',
            'type_name' => ' أطعمة مالحة',
        ]);//21
        Type::create([
            'class_id' => '6',
            'type_name' => 'حلويات',
        ]);//22
        Type::create([
            'class_id' => '6',
            'type_name' => 'غير ذلك',
        ]);//23
    }
}
