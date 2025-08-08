<?php

namespace Database\Seeders;

use App\Models\StoreClass;

use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;

class StoreClassSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        //
        StoreClass::create([
            'class_name' => 'زينة حفلات',//1
        ]);
        StoreClass::create([
            'class_name' => 'برمجة',//2
        ]);
        StoreClass::create([
            'class_name' => 'ملبوسات',//3
        ]);
        StoreClass::create([
            'class_name' => 'مواد طبيعية',//4
        ]);
        StoreClass::create([
            'class_name' => 'اعمال يدوية',//5
        ]);
        StoreClass::create([
            'class_name' => 'غذائيات',//6
        ]);
    
        StoreClass::create([
            'class_name' => 'غير ذلك',//7
        ]);
    }
}
