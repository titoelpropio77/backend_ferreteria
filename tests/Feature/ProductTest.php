<?php

namespace Tests\Feature;

use App\Models\Product;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Tests\TestCase;

class ProductTest extends TestCase
{
    use RefreshDatabase;
    /**
     *
     *
     */
    public function test_it_validate_response_product(): void
    {
        Product::factory()->create();
        $response = $this->get('api/clients');
        $response->assertStatus(200);
    }


    public function test_it_validate_create_product(): void
    {
        $product =  Product::factory()->make();
        $response = $this->post('api/products', $product->toArray());
        $response->assertStatus(201);
        $this->assertDatabaseHas('products', $product->toArray());
    }
}
