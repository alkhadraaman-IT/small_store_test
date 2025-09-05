<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Product extends Model
{
    //
    protected $fillable = [
        'store_id',
        'product_name',
        'type_id',
        'product_description',
        'product_price',
        'product_available',
        'product_state',
        'product_photo_1',
        'product_photo_2',
        'product_photo_3',
        'product_photo_4'
    ];
 public function store()
    {
        return $this->belongsTo(Store::class); // منتج يتبع لمحل واحد
    }

public function type()
    {
        return $this->belongsTo(Type::class); // منتج يتبع نوع واحد
    }
    
public function favorites()
    {
return $this->hasMany(Favorite::class); // ✅
    }

      protected $casts = [
    'product_state' => 'integer',
    'product_available' => 'integer',
];

// Accessor لإرجاع رابط الصورة كامل
public function getProductPhoto1UrlAttribute()
{
    return $this->product_photo_1 
        ? url('storage/products/' . $this->product_photo_1)
        : null;
}

public function getProductPhoto2UrlAttribute()
{
    return $this->product_photo_2 
        ? url('storage/products/' . $this->product_photo_2)
        : null;
}

public function getProductPhoto3UrlAttribute()
{
    return $this->product_photo_3 
        ? url('storage/products/' . $this->product_photo_3)
        : null;
}

public function getProductPhoto4UrlAttribute()
{
    return $this->product_photo_4 
        ? url('storage/products/' . $this->product_photo_4)
        : null;
}

}
