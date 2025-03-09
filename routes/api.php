<?php

use App\Http\Controllers\ClientController;
use App\Http\Controllers\EmployeeController;
use Illuminate\Support\Facades\Route;


Route::apiResource('clients', ClientController::class);
Route::apiResource('employees', EmployeeController::class);
