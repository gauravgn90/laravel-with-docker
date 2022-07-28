<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\CompanyCRUDController;
/*
|--------------------------------------------------------------------------
| Web Routes
|--------------------------------------------------------------------------
|
| Here is where you can register web routes for your application. These
| routes are loaded by the RouteServiceProvider within a group which
| contains the "web" middleware group. Now create something great!
|
*/

Route::get('/', function () {
    return view('welcome');
});
Route::get('/ok', function () {
    return "ok";
});
Route::get('/fail', function () {
    return "failed";
});
Route::get('/not-found', function () {
    return "no found";
});

Route::resource('companies', CompanyCRUDController::class);
