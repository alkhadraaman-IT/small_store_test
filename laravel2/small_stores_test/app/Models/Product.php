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
}
