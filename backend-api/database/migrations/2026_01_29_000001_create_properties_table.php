<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('properties', function (Blueprint $table) {
            $table->uuid('id')->primary();
            $table->foreignId('user_id')->constrained('users')->cascadeOnDelete();
            $table->string('address', 500);
            $table->integer('surface');
            $table->integer('price');
            $table->string('property_type');
            $table->string('agent_name', 255)->nullable();
            $table->string('agent_agency', 255)->nullable();
            $table->string('agent_phone', 50)->nullable();
            $table->string('sale_urgency')->default('not_specified');
            $table->text('notes')->nullable();
            $table->timestamps();
            $table->softDeletes();

            $table->index('user_id');
            $table->index('property_type');
            $table->index('sale_urgency');
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('properties');
    }
};
