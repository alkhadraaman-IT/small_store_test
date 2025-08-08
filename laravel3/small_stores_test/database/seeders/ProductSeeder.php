<?php

namespace Database\Seeders;

use App\Models\Product;

use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;

class ProductSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        //
        Product::create([
            'store_id' => '2',
            'product_name' => 'كنزة قطن',
            'type_id' => '10',
            'product_description' => 'قطن 100% ألوان :أحمر وأسود فقط القياس 7و8',
            'product_price' => '50000',
            'product_photo_1' => 'default.png',
        ]);
        Product::create([
            'store_id' => '2',
            'product_name' => ' كنزة قطن نص كم',
            'type_id' => '11',
            'product_description' => 'قطن 100% ألوان :أحمر وأسود فقط القياس 40و50',
            'product_price' => '55000',
            'product_photo_1' => 'default.png',
        ]);
        Product::create([
            'store_id' => '2',
            'product_name' => 'كنزة قطن كم طويل',
            'type_id' => '12',
            'product_description' => 'قطن 100% ألوان :أحمر وأسود فقط القياس40و42',
            'product_price' => '65000',
            'product_photo_1' => 'default.png',
        ]);
        Product::create([
            'store_id' => '1',
            'product_name' => 'شعار مقهى',
            'type_id' => '6',
            'product_description' => 'يعبر عن المشروبات الساحنة مع تناسق الالوان',
            'product_price' => '20000',
            'product_photo_1' => 'default.png',
        ]);
        Product::create([
            'store_id' => '1',
            'product_name' => 'شعار مكتبة',
            'type_id' => '6',
            'product_description' => 'يعبر عن العلم ولونه يحفز التعلم ',
            'product_price' => '20000',
            'product_photo_1' => 'default.png',
        ]);
        Product::create([
            'store_id' => '3',
            'product_name' => ' كنزة نص كم',
            'type_id' => '11',
            'product_description' => 'قطن 100% ألوان :أحمر وأسود فقط القياس 40و50',
            'product_price' => '55000',
            'product_photo_1' => 'default.png',
        ]);
        Product::create([
            'store_id' => '3',
            'product_name' => 'كنزة كم طويل',
            'type_id' => '13',
            'product_description' => 'قطن 100% ألوان :أحمر وأسود فقط القياس2 و4 ',
            'product_price' => '65000',
            'product_photo_1' => 'default.png',
        ]);
    }
}
