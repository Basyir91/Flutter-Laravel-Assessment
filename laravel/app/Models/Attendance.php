<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Attendance extends Model
{
    use HasFactory;
  
    protected $fillable = [
        'user_id',
        'date',
        'place_id',
        'check_in',
        'check_out',
    ];
}
