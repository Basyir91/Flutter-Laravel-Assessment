<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\AttendanceController;
use App\Http\Controllers\PlaceController;
use App\Http\Controllers\UserController;

Route::get('/', function () {
    return view('welcome');
});

Route::resource('attendances', AttendanceController::class);
Route::resource('places', PlaceController::class);
Route::resource('users', UserController::class);