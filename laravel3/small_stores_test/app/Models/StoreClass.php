<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class StoreClass extends Model
{
    //
    public function types()
    {
        return $this->hasMany(Type::class); 
    }

    public function stores()
    {
        return $this->hasMany(Store::class);
    }
}
