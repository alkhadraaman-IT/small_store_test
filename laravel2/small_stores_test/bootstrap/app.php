<?php

use Illuminate\Foundation\Application;
use Illuminate\Foundation\Configuration\Exceptions;
use Illuminate\Foundation\Configuration\Middleware;

return Application::configure(basePath: dirname(__DIR__))
    ->withRouting(
        web: __DIR__.'/../routes/web.php',
        commands: __DIR__.'/../routes/console.php',
        health: '/up',
    )
    ->withMiddleware(function (Middleware $middleware) {
        // أضف middleware الـ CORS هنا
        $middleware->append(\App\Http\Middleware\Cors::class);
        
        // أو إذا أردت تطبيقه على routes معينة فقط
        // $middleware->group('api', [
        //     \App\Http\Middleware\Cors::class,
        // ]);
    })
  
    ->withExceptions(function (Exceptions $exceptions) {
        //
    })->create();