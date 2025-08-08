<?php

namespace Database\Seeders;

use App\Models\User;

use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;

class UserSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        //
        User::create([
            'name' => 'admin',
            'email' => 'admin@test.com',
            'phone' => '0987654321',
            'password' => '123',
            'profile_photo' => 'default.png',
            'type' =>false,
        ]);
        User::create([
            'name' => 'user1',
            'email' => 'user1@test.com',
            'phone' => '0987654322',
            'password' => '123',
            'profile_photo' => 'default.png',
        ]);
        User::create([
            'name' => 'user2',
            'email' => 'user2@test.com',
            'phone' => '0987654333',
            'password' => '123',
            'profile_photo' => 'default.png',
        ]);
        /*User::create([
            'name' => 'user3',
            'email' => 'user3@test.com',
            'phone' => '0987544444',
            'password' => Hash::make('123'),
            'profile_photo' => 'default.png',
        ]);
        User::create([
            'name' => 'user4',
            'email' => 'user4@test.com',
            'phone' => '0987655555',
            'password' => Hash::make('123'),
            'profile_photo' => 'default.png',
        ]);*/
    }
}
