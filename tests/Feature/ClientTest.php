<?php

namespace Tests\Feature;

use App\Models\Client;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Tests\TestCase;

class ClientTest extends TestCase
{
    use RefreshDatabase;
    /**
     *
     *
     */
    public function test_it_validate_response_client(): void
    {
        Client::factory()->create();
        $response = $this->get('api/clients');
        $response->assertStatus(200);
    }


    public function test_it_create_client(): void
    {
        $client =  Client::factory()->make();
        $response = $this->post('api/clients', $client->toArray());
        $response->assertStatus(201);
        $this->assertDatabaseHas('clients', $client->toArray());
    }
}
