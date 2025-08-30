<?php

namespace App\Models;

// use Illuminate\Contracts\Auth\MustVerifyEmail;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Foundation\Auth\User as Authenticatable;
use Illuminate\Notifications\Notifiable;
use Laravel\Sanctum\HasApiTokens;

class User extends Authenticatable
{
  
     /** @use HasFactory<\Database\Factories\UserFactory> */
   // use HasFactory, Notifiable;
use HasApiTokens, HasFactory, Notifiable;

       // use HasApiTokens, HasFactory, Notifiable;

    /**
     * The attributes that are mass assignable.
     *
     * @var list<string>
     */
    protected $fillable = [
    'name',
    'email',
    'phone',
    'password',
    'profile_photo',
    'type',
    'status',
];


    /**
     * The attributes that should be hidden for serialization.
     *
     * @var list<string>
     */
    protected $hidden = [
        'password',
        'remember_token',
    ];

    /**
     * Get the attributes that should be cast.
     *
     * @return array<string, string>
     */
   protected $casts = [
    'email_verified_at' => 'datetime',
    'password' => 'hashed',
];


    public function stores()
    {
        return $this->hasMany(Store::class);
    }

public function favorites()
    {
return $this->hasMany(Favorite::class); // ✅
    }
    
}
