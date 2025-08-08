<?php

namespace Database\Seeders;

use App\Models\Store;

use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;

class StoreSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        //
        Store::create([
            'user_id' => '2',
            'store_name' => 'برامجك',
            'store_phone' => '0987654321',
            'store_place' =>'دمشق بجوار جامع أبو النور',
            'class_id' => '2',
            'store_description' => 'نبيع أفضل المنتجات بأسعار منافسة',
            'store_photo' => 'default.png',
        ]);
        Store::create([
            'user_id' => '1',
            'store_name' => 'ملبوساتك',
            'store_phone' => '0987654322',
            'store_place' =>'دمشق بجوار جامع الرحمن',
            'class_id' => '3',
            'store_description' => 'نبيع أفضل المنتجات بأسعار منافسة',
            'store_photo' => 'default.png',
        ]);
        Store::create([
            'user_id' => '2',
            'store_name' => 'من عنا',
            'store_phone' => '0987654333',
            'store_place' =>'دمشق بجوار جامع التقوى',
            'class_id' => '3',
            'store_description' => 'نبيع أفضل المنتجات بأسعار منافسة',
            'store_photo' => 'default.png',
            ]);
    }
}
