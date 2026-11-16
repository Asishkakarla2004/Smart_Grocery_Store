# REST API
Base path: `/api/v1`. Swagger UI: `/swagger-ui/index.html`.

| Method | Endpoint | Description |
|---|---|---|
| GET | `/products?search=rice` | List/search active products |
| GET | `/products/{id}` | Product detail |
| POST | `/products` | Create product (JSON name/category/price/unit) |
| PUT | `/products/{id}` | Update product |
| DELETE | `/products/{id}` | Delete product |
| GET | `/inventory` | List inventory |
| POST | `/inventory/{id}/add?quantity=5` | Add stock |
| POST | `/inventory/{id}/remove?quantity=2` | Remove stock |
| POST | `/inventory/{id}/adjust?quantity=-1` | Adjust stock by signed delta |
| GET | `/orders` | List orders |
| POST | `/orders` | Create basic order (JSON customerName/total) |
| PUT | `/orders/{id}/status?value=PACKED` | Update order status |
| GET | `/health` | Application API health |
| POST | `/ai/parse-stock-command` | Provider-not-configured response for voice command |

The current security configuration is permissive for development. Do not expose it publicly until JWT authentication, role authorization, request validation and endpoint-specific authorization are implemented. Authentication endpoints and full endpoint set from the product specification remain future work.
