<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::table('contacts', function (Blueprint $table) {
            $table->string('first_name', 255)->after('user_id')->default('');
            $table->string('last_name', 255)->after('first_name')->default('');
        });

        DB::table('contacts')->update([
            'last_name' => DB::raw('`name`'),
            'first_name' => '',
        ]);

        Schema::table('contacts', function (Blueprint $table) {
            $table->string('first_name', 255)->default(null)->change();
            $table->string('last_name', 255)->default(null)->change();
            $table->dropColumn('name');
        });
    }

    public function down(): void
    {
        Schema::table('contacts', function (Blueprint $table) {
            $table->string('name', 255)->after('user_id')->default('');
        });

        DB::table('contacts')->update([
            'name' => DB::raw("CONCAT(`first_name`, ' ', `last_name`)"),
        ]);

        Schema::table('contacts', function (Blueprint $table) {
            $table->string('name', 255)->default(null)->change();
            $table->dropColumn(['first_name', 'last_name']);
        });
    }
};
