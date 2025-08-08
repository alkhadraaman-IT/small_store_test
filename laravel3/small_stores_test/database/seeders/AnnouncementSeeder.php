<?php

namespace Database\Seeders;

use App\Models\Announcement;

use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;

class AnnouncementSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        //
        Announcement::create([
            'store_id' => '1',
            'announcement_description' => 'خفضنا الاسعاار',
            'announcement_date' => '2025-08-02',
            'announcement_photo' => 'default.png',
        ]);
    }
}
