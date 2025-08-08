<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::create('products', function (Blueprint $table) {
            $table->id();
            $table->foreignId('store_id')->constrained('stores');
            $table->string('product_name');
            $table->foreignId('type_id')->constrained('types');
            $table->string('product_description');
            $table->integer('product_price');
            $table->boolean('product_available')->default(true); 
            $table->boolean('product_state')->default(true); 
            $table->string('product_photo_1');
            $table->string('product_photo_2')->nullable();
            $table->string('product_photo_3')->nullable();
            $table->string('product_photo_4')->nullable();
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('products');
    }
};
