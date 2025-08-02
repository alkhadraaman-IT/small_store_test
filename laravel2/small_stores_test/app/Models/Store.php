<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Store extends Model
{
    //
    protected $fillable = [
    'user_id',
    'store_name',
    'store_phone',
    'store_place',
    'class_id',
    'store_description',
    'store_state',
    'store_photo'
];

public function user()
{
    return $this->belongsTo(User::class);
}

public function storeClass()
    {
        return $this->belongsTo(StoreClass::class); 
    }

    public function products()
    {
        return $this->hasMany(Product::class); // صححنا العلاقة
    }

    public function announcements()
    {
        return $this->hasMany(Announcement::class); // ← صححنا العلاقة هون
    }

}
