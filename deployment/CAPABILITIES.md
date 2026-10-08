# Monarch connector capabilities

Verified from the registered MCP tools at upstream commit 3bbb0256d34ad8246d96086b844f52a0ebeae202.

61 registered tools, 30 mutating. Registration is verified; live Monarch behavior remains untested until secure sign-in.

| Tool | Effect | Required inputs |
|---|---|---|
| `add_transaction_tag` | Mutating | `transaction_id`, `tag_id` |
| `bulk_categorize_transactions` | Mutating | `transaction_ids`, `category_id` |
| `bulk_update_transactions` | Mutating | `transaction_ids` |
| `categorize_transaction` | Mutating | `transaction_id`, `category_id` |
| `check_auth_status` | Read or setup guidance |  |
| `create_transaction` | Mutating | `date`, `account_id`, `amount`, `merchant_name`, `category_id` |
| `create_transaction_category` | Mutating | `group_id`, `transaction_category_name` |
| `create_transaction_rule` | Mutating |  |
| `create_transaction_tag` | Mutating | `name`, `color` |
| `debug_session_loading` | Read or setup guidance |  |
| `delete_transaction` | Mutating | `transaction_id` |
| `delete_transaction_rule` | Mutating | `rule_id` |
| `get_account_balance_history` | Read or setup guidance | `account_id` |
| `get_account_holdings` | Read or setup guidance | `account_id` |
| `get_account_sync_health` | Read or setup guidance |  |
| `get_accounts` | Read or setup guidance |  |
| `get_budgets` | Read or setup guidance |  |
| `get_business_entities` | Read or setup guidance |  |
| `get_cashflow` | Read or setup guidance |  |
| `get_cashflow_by_month` | Read or setup guidance | `start_date`, `end_date` |
| `get_category_details` | Read or setup guidance | `category_id` |
| `get_debt_paydown` | Read or setup guidance |  |
| `get_goal_contributions` | Read or setup guidance | `goal_id` |
| `get_goals` | Read or setup guidance |  |
| `get_merchant` | Read or setup guidance | `merchant_id` |
| `get_net_worth` | Read or setup guidance |  |
| `get_net_worth_by_account_type` | Read or setup guidance | `start_date` |
| `get_recurring_transactions` | Read or setup guidance |  |
| `get_spending_summary` | Read or setup guidance |  |
| `get_transaction_categories` | Read or setup guidance |  |
| `get_transaction_category_groups` | Read or setup guidance |  |
| `get_transaction_details` | Read or setup guidance | `transaction_id` |
| `get_transaction_rules` | Read or setup guidance |  |
| `get_transaction_splits` | Read or setup guidance | `transaction_id` |
| `get_transaction_tags` | Read or setup guidance |  |
| `get_transactions` | Read or setup guidance |  |
| `get_transactions_needing_review` | Read or setup guidance |  |
| `get_transactions_summary` | Read or setup guidance |  |
| `mark_transaction_reviewed` | Mutating | `transaction_id` |
| `monarch_login` | Mutating |  |
| `monarch_login_with_token` | Mutating |  |
| `monarch_logout` | Mutating |  |
| `monarch_whoami` | Read or setup guidance |  |
| `refresh_accounts` | Mutating |  |
| `reorder_transaction_rule` | Mutating | `rule_id`, `new_order` |
| `review_recurring_stream` | Mutating | `stream_id`, `review_status` |
| `search_transactions` | Read or setup guidance |  |
| `set_budget_amount` | Mutating | `amount` |
| `set_business_entity` | Mutating | `transaction_id`, `business_entity_id` |
| `set_goal_contribution` | Mutating | `goal_id`, `account_id`, `amount` |
| `set_transaction_tags` | Mutating | `transaction_id`, `tag_ids` |
| `setup_authentication` | Read or setup guidance |  |
| `split_transaction` | Mutating | `transaction_id`, `splits` |
| `update_account` | Mutating | `account_id` |
| `update_category` | Mutating | `category_id` |
| `update_merchant` | Mutating | `merchant_id` |
| `update_savings_goal` | Mutating | `goal_id` |
| `update_transaction` | Mutating | `transaction_id` |
| `update_transaction_notes` | Mutating | `transaction_id`, `notes` |
| `update_transaction_rule` | Mutating | `rule_id` |
| `upload_account_balance_history` | Mutating | `account_id`, `corrections` |

## Coverage and limits

Accounts, holdings and balance history; transactions and pagination; categories and groups; tags; splits; budgets; cash flow and net worth; goals and contributions; recurring forecasts and merchant streams; transaction rules; debt payoff; business entities; institution sync health; and session management are exposed.

A tool list does not establish full parity with Monarch’s app. Account creation/deletion, transfers of money, bill payment, institution linking, document upload, investment trading, and complete household settings are not advertised as connector capabilities. Do not infer them from transaction tools.

All tools share one saved Monarch session. Login, logout and token replacement are mutating. The upstream tools currently omit readOnlyHint, so ChatGPT may request confirmation for reads as well as writes. Keep client confirmation behavior in place.

No real records have been used as test fixtures. All 466 upstream tests passed on October 7, 2026, with locked dependencies.
