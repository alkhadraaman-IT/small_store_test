<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Announcement extends Model
{
    //
    protected $fillable = [
    'store_id',
    'announcement_description',
    'announcement_date',
    'announcement_state',
    'announcement_photo'
];

    public function store()
    {
        return $this->belongsTo(Store::class); // ← هون كانت الغلطة: كنت رابطها بـ User بدل Store
    }

    protected $casts = [
    'announcement_state' => 'integer',
];

}
