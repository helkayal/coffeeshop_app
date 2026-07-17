# Coffee Shop App — Complete Screen Documentation

> **Generated:** 2026-06-22  
> **Total screens:** 19  
> **Tech stack:** Flutter (Dart 3.10+) · flutter_bloc/Cubit · easy_localization · Hive

---

## Architecture Overview

```
App Entry (main.dart)
  ├── OnboardingScreen      [/onboarding]
  ├── LoginScreen           [/login]
  ├── RegisterScreen        [/register]
  └── MainShell             [/] — Bottom nav shell with 4 tabs + secondary overlay routing
       ├── Tab 0: HomeScreen
       ├── Tab 1: MenuScreen
       ├── Tab 2: FavoritesScreen
       └── Tab 3: AccountScreen
            └── (secondary screens pushed over tabs)
            ├── EditProfileScreen
            ├── WalletScreen (→ TopUpSheet)
            ├── PaymentMethodsScreen (→ AddCardForm)
            ├── ReferralScreen
            ├── ViewBenefitsScreen
            ├── CartScreen
            ├── PaymentScreen (→ CreditCardSheet / WalletSheet)
            ├── OrderConfirmationScreen
            ├── CustomizationScreen
            ├── OrdersScreen
            └── SettingsScreen (→ LanguagePickerSheet)
```

**Navigation system:** `MainShell` uses an `IndexedStack` for the 4 tabs + a `ShellRouter` for secondary routes. Secondary screens render as opaque overlays via `ShellCubit.pushSecondary()`.

---

## 1. Onboarding Screen

**Route:** `/onboarding`  
**File:** `features/onboarding/presentation/screens/onboarding_screen.dart`  
**State:** `OnboardingCubit`

### Layout (top → bottom)

| Section | Content |
|---|---|
| **Skip Row** | Text: "Don't want to take the survey." + "**skip**" link |
| **Question Page** (scrollable body) | Image (optional) + question text + selectable option tiles |
| **Bottom Bar** | Back button (after first step) + ProgressDots + Spacer |

### Questions & Options

**Q1: "How do you like your coffee?"**
- Option 1: "Black & Bold"
- Option 2: "Sweet & Creamy"
- Option 3: "Balanced"

**Q2: "Which flavor profile do you prefer?"**
- Option 1: "Nutty & Chocolatey"
- Option 2: "Fruity & Bright"
- Option 3: "Spiced & Warm"

**Q3: "What is your preferred milk?"**
- Option 1: "Whole Milk"
- Option 2: "Oat Milk"
- Option 3: "Almond Milk"
- Option 4: "No Milk (Vegan)"

### UI Components
- `SkipRow` — centered text + tappable skip link
- `QuestionPage` — image (optional, bordered container), question text, list of `OptionTile` widgets
- `OptionTile` — tappable bordered container, selected state has primary color border + check icon
- `ProgressDots` — animated horizontal dots (current step is wider, 24px vs 8px)
- `LoadingView` / `ErrorView` — full-screen states

### Behavior
- Selecting an option auto-advances after 300ms delay
- Back button navigates to previous question
- Skip navigates directly to login
- On completion → navigates to `/login`

---

## 2. Login Screen

**Route:** `/login`  
**File:** `features/auth/presentation/screens/login_screen.dart`  
**State:** `AuthCubit`

### Layout (top → bottom)

| # | Section | Content |
|---|---|---|
| 1 | **Auth Header** | App name ("Coffee Shop") + title "Welcome Back" + subtitle "Enter your details to access your curated experience." |
| 2 | **Login Form** | Two text fields (see below) |
| 3 | **Forgot Password** | Right-aligned text button |
| 4 | **Sign In Button** | Full-width `AppButton` (primary) with loading state |
| 5 | **Register Link** | "Don't have account? **Create one**" → navigates to `/register` |
| 6 | **Social Login** | Divider "CONTINUE WITH SOCIAL" + 3 social buttons |

### Form Fields

| # | Field | Placeholder | Keyboard Type | Prefix Icon | Suffix Icon | Controller |
|---|---|---|---|---|---|---|
| 1 | Email | "Email Address" | email | `email_outlined` | — | `_emailController` |
| 2 | Password | "Password" | text (obscured) | `lock_outline` | `visibility_off_outlined` | `_passwordController` |

### Social Buttons
- Google icon (`g_mobiledata`) — 46px
- Facebook icon (`facebook`) — 30px
- Apple icon (`apple`) — 30px

### States
- `AuthLoading` → Sign In button shows spinner
- `AuthError` → snackbar with error message
- `AuthAuthenticated` → navigate to `/`

---

## 3. Register Screen

**Route:** `/register`  
**File:** `features/auth/presentation/screens/register_screen.dart`  
**State:** `AuthCubit`

### Layout (top → bottom)

| # | Section | Content |
|---|---|---|
| 1 | **Auth Header** | App name ("Coffee Shop") + title "Join the Club" + subtitle "Create your account to access your curated experience." |
| 2 | **Profile Picture** | Gender-based placeholder image (`male_placeholder.png` or `female_placeholder.png`) with edit icon overlay |
| 3 | **Name Fields** | First Name + Last Name (side-by-side) |
| 4 | **Email Field** | Email text field |
| 5 | **Gender Selection** | "GENDER" label + Male / Female radio options |
| 6 | **Location Section** | State dropdown + City dropdown (dependent, Egyptian locations) |
| 7 | **Password Field** | Password text field (obscured) |
| 8 | **Register Button** | Full-width `AppButton` "Register" |
| 9 | **Login Link** | "If you have an account **Login**" → navigates to `/login` |

### Form Fields

| # | Field | Placeholder/Values | Controller/Notifier |
|---|---|---|---|
| 1 | First Name | "First Name" | `_firstNameController` |
| 2 | Last Name | "Last Name" | `_lastNameController` |
| 3 | Email | "Email Address" | `_emailController` |
| 4 | Gender | "Male" / "Female" | `_genderNotifier` (default: 'male') |
| 5 | State | Select from: Cairo, Giza, Alexandria, Dakahlia, Red Sea | `_stateNotifier` |
| 6 | City | Select from cities in chosen state | `_cityNotifier` |
| 7 | Password | "Password" (obscured) | `_passwordController` |

### Egyptian Locations Data
- **Cairo:** Cairo City, New Cairo, Nasr City, Maadi
- **Giza:** Giza City, 6th of October, Sheikh Zayed
- **Alexandria:** Alexandria City, Burj Al Arab
- **Dakahlia:** Mansoura, Talkha
- **Red Sea:** Hurghada, El Gouna

### Profile Picture
- Shows `male_placeholder.png` (default) or `female_placeholder.png`
- Has edit icon (pen) overlay at bottom-right in primary color circle

### States
- Same as Login: Loading → spinner, Error → snackbar, Authenticated → navigate to `/`

---

## 4. Home Screen (Tab 0)

**File:** `features/home/presentation/screens/home_screen.dart` → `HomeBody`  
**State:** `OrdersCubit` (for last order)

### Layout (top → bottom)

| # | Section | Content |
|---|---|---|
| 1 | **Home Profile Section** | Avatar (48px circle, `male_placeholder.png`) + "Welcome," + "Ahmed Gamal" + Points "1,250" / "Points" |
| 2 | **Featured Items View** | Horizontal scrollable cards (5 items, alternating) |
| 3 | **Your Last Order header** | Section title "Your Last Order" |
| 4 | **Last Order Card** | Order item card with image + name + desc + price + replay action |
| 5 | **Explore Menu Button** | Full-width button → switches to Menu tab |

### Featured Items (horizontal ListView, 40vh height, 85vw width)
Alternating pattern:
- Even indices: `FeaturedItemCard` — "Cardamom Rose Latte"
- Odd indices: `PromoBanner` — "The Autumn Equinox Blend" with "20% OFF" badge

**FeaturedItemCard — "Cardamom Rose Latte"**
| Element | Value |
|---|---|
| Image | `cardamom_cose_latte.png` |
| Name | "Cardamom Rose Latte" |
| Description | "Robust espresso, steamed oat milk, and house-made cardamom-rose syrup." |
| Price | "$7.25" |
| Action Button | Primary circle button with cart icon → opens `QuickAddOverlay` |

**PromoBanner**
| Element | Value |
|---|---|
| Image | `artisanal_coffee_brewing.png` |
| Badge | Rotated pill "20% OFF" in primary color, top-right |
| Gradient | Black gradient overlay bottom |
| Overlay text | "Limited Release" (label) + "The Autumn Equinox Blend" (title) |

**Last Order Card**
| Element | Value |
|---|---|
| Image | `coffee_preparation.png` (80×80) |
| Name | "Ethiopian Yirgacheffe" (or latest order name if available) |
| Description | "Pour Over • Light Roast" (or "Order #ID · Status") |
| Price | "$6.50" |
| Action | `replay` icon button (outlined circle) |

**Explore Menu Button**
| Element | Value |
|---|---|
| Text | "Explore Our Menu" |
| Icon | `arrow_forward` |
| Action | `ShellCubit.selectTab(1)` — switches to Menu tab |

---

## 5. Menu Screen (Tab 1)

**File:** `features/menu/presentation/screens/menu_screen.dart`  
**State:** `MenuCubit`

### Layout (top → bottom)

| # | Section | Content |
|---|---|---|
| 1 | **Menu Header** | "Our Menu" (EB Garamond, 36px, color #ECE0D6) + divider line |
| 2 | **Category Chips** | Horizontal scrollable category filter chips |
| 3 | **Product List** | Vertical list of `ProductListItem` cards |

### Categories (4 total)

| # | ID | Name | Image |
|---|---|---|---|
| 1 | `'1'` | "Reserve Roasts" | `reserve_roasts.png` |
| 2 | `'2'` | "Cold Brew" | `cold_brew.png` |
| 3 | `'3'` | "Signature Lattes" | `signature_lattes.png` |
| 4 | `'4'` | "Pastries" | `pastries.png` |

Includes "All" chip that resets filter (shows all products).

### Products (6 total)

| # | ID | Name | Description | Image | Price | Category |
|---|---|---|---|---|---|---|
| 1 | `'1'` | Ethiopian Yirgacheffe | "Floral notes with a bright, citrusy finish. Hand-picked and sun-dried." | `coffee_preparation.png` | $6.50 | Reserve Roasts |
| 2 | `'2'` | Honey Cardamom Latte | "Warm spices balanced with local wildflower honey." | `latte_art_being_poured.png` | $7.25 | Signature Lattes |
| 3 | `'3'` | Desert Midnight | "Steeped for 24 hours. Smooth, bold, and entirely without bitterness." | `artisanal_coffee_brewing.png` | $5.75 | Cold Brew |
| 4 | `'4'` | Almond Croissant | "Flaky layers filled with rich almond frangipane." | `coffee_preparation.png` | $4.50 | Pastries |
| 5 | `'5'` | Cardamom Rose Latte | "Robust espresso, steamed oat milk, and house-made cardamom-rose syrup." | `latte_art_being_poured.png` | $7.25 | Signature Lattes |
| 6 | `'6'` | Butter Croissant | "Classic French croissant with a golden, flaky crust." | `coffee_preparation.png` | $3.75 | Pastries |

### Each Product List Item contains:
- Product image (120px wide)
- Product name + favorite toggle (heart icon)
- Description (max 2 lines)
- "Customize" link → pushes `CustomizationScreen`
- Cart add button (circle with `add_shopping_cart` icon) → opens `QuickAddOverlay`

### States
- `MenuLoading` → centered spinner
- `MenuError` → error text
- `MenuLoaded` → full list with chips

---

## 6. Favorites Screen (Tab 2)

**File:** `features/favorites/presentation/screens/favorites_screen.dart`  
**State:** `FavoritesCubit`

### Layout

| Element | Content |
|---|---|
| Title | "Your Favorites" (30px) |

### Each Favorite Item Card

| Element | Value |
|---|---|
| Image | Product image (96×96, rounded 12px) |
| Name | Product name |
| Favorite button | Filled heart (red/primary) |
| Description | Product description (max 2 lines) |
| Price | e.g. "$7.25" (18px, primary color) |
| Cart button | Circle icon button → opens `QuickAddOverlay` |

### States
- `FavoritesLoading` → centered spinner
- `FavoritesError` → error message
- `FavoritesLoaded` (empty) → "No favorites" message
- `FavoritesLoaded` (with items) → list of `FavoriteItemCard`

---

## 7. Account Screen (Tab 3)

**File:** `features/account/presentation/screens/account_screen.dart`  
**State:** `ShellCubit` (for navigation)

### Layout (top → bottom)

| # | Section | Element | Details |
|---|---|---|---|
| 1 | **Profile Card** (tappable) | Avatar (56px circle, `male_placeholder.png`) + Name "Ahmed Gamal" + "View Profile" + chevron right | → pushes `EditProfileScreen` |
| 2 | **Loyalty Card** | Card image + tier name + points display + progress bar + "View My Benefits" link | → pushes `ViewBenefitsScreen` |
| 3 | **Wallet** | `AccountCard` — `account_balance_wallet` icon, "Wallet" label | → pushes `WalletScreen` |
| 4 | **Payment Methods** | `AccountCard` — `payments` icon, "Payment" label | → pushes `PaymentMethodsScreen` |
| 5 | **Referral** | `AccountCard` — `card_giftcard` icon, "My Referral" label | → pushes `ReferralScreen` |
| 6 | **Order History** | `AccountCard` — `history` icon, "Order History" label | → pushes `OrdersScreen` |

### Loyalty Card (embedded)
- Shows tier card image with colored overlay (based on tier)
- Points: e.g. "580" + coffee bean icon
- Target: e.g. "N points to Silver" with chevron
- Progress bar with 4 tier markers
- "View My Benefits" link → pushes `ViewBenefitsScreen`

### Loyalty Tiers

| Tier | Name | Color | Points Range |
|---|---|---|---|
| 0 (Blue) | "Blue" | `#0000FF` | 0–179 |
| 1 (Silver) | "Silver" | `#696E74` | 180–499 |
| 2 (Gold) | "Gold" | `#FF891C` | 500–999 |
| 3 (Platinum) | "Platinum" | `#707BE3` | 1000+ |

### AppBar Actions (only on Account tab when nothing is open on top)
- **Settings gear** (left action) → pushes `SettingsScreen`
- **Cart icon** (right action) → pushes `CartScreen`

---

## 8. Edit Profile Screen

**Route:** pushed as secondary from Account  
**File:** `features/account/presentation/screens/edit_profile_screen.dart`

### Layout (top → bottom)

| # | Section | Content |
|---|---|---|
| 1 | **Profile Avatar** | 128px circle photo (`male_placeholder.png`) with border + edit icon at bottom-right |
| 2 | **"ACCOUNT" section header** | Small uppercase label in primary color |
| 3 | **Full Name** | Label "Full Name" · Value "Ahmed Gamal" + edit icon |
| 4 | **Email** | Label "Email" · Value "ahmed.gamal@example.com" + edit icon |
| 5 | **Gender** | Label "Gender" · Value "Male" + edit icon |
| 6 | **Date of Birth** | Label "Date of Birth" · Value "01/15/1992" + edit icon |
| 7 | **Location** | Label "State - City" · Value "Cairo, Egypt" + edit icon |
| 8 | **Sign Out Button** | Full-width outlined red button "Sign Out" with logout icon |

### Profile Fields (5 fields)
Each `ProfileField` is a bordered card with:
- Label (small, above)
- Value
- Edit icon button on the right

---

## 9. Wallet Screen

**Route:** pushed as secondary from Account  
**File:** `features/account/presentation/screens/wallet_screen.dart`

### Layout (top → bottom)

| # | Section | Content |
|---|---|---|
| 1 | **Balance Card** | Wallet icon (48px) + "Current Balance" label + "250 EGP" (36px bold) |
| 2 | **Top Up Button** | Full-width filled button "Top Up Balance" with + icon → opens `TopUpSheet` |
| 3 | **"Recent Transactions" header** | Section title |
| 4 | **Transaction list** | 3 transaction tiles |

### Transactions

| # | Icon | Label | Amount | Color |
|---|---|---|---|---|
| 1 | `add_circle` | "Wallet Top Up" | "+100 EGP" | Primary (green) |
| 2 | `remove_circle` | "Coffee Purchase" | "-45 EGP" | Error (red) |
| 3 | `add_circle` | "Wallet Top Up" | "+200 EGP" | Primary (green) |

### TopUpSheet (Bottom Sheet)
- Handle bar (48px × 4px)
- Title "Top Up Balance"
- `PaymentMethodSelector` — use points / credit card / wallets / apple pay
- "Add Balance" filled button

### Wallet Balance
- Static constant: **250.00 EGP**

---

## 10. Payment Methods Screen

**Route:** pushed as secondary from Account  
**File:** `features/account/presentation/screens/payment_methods_screen.dart`

### Layout (top → bottom)

| # | Section | Content |
|---|---|---|
| 1 | **"Saved Cards" header** | Section title |
| 2 | **Card: •••• 4242** | Credit card icon + mask + "Expires 12/28" + Default badge, radio selected |
| 3 | **Card: •••• 8371** | Credit card icon + mask + "Expires 06/27", radio unselected |
| 4 | **"Add New Card" button** | Outlined button with + icon → opens `AddCardForm` bottom sheet |
| 5 | **"Other Payment Methods" header** | Section title |
| 6 | **Wallet option** | `account_balance_wallet` icon, "Wallets", Default badge, radio |
| 7 | **Apple Pay option** | `contactless` icon, "Apple Pay", Default badge, radio |

### Saved Cards (2 cards)
- Card ending in 4242, expires 12/28
- Card ending in 8371, expires 06/27

### Selection
- Single-select radio buttons, state managed by `_selected`

---

## 11. Referral Screen

**Route:** pushed as secondary from Account  
**File:** `features/account/presentation/screens/referral_screen.dart`

### Layout (top → bottom)

| # | Section | Content |
|---|---|---|
| 1 | **Referral Code Card** | Share icon (48px) + "Your Referral Code" label + "**COFFEE50**" (28px, spaced letters) + "Share this code with friends and earn" + "50 Points per referral!" |
| 2 | **"Referral History" header** | Section title |
| 3 | **Referral list** | 4 referral tiles |

### Referral History

| # | Name | Points | Date |
|---|---|---|---|
| 1 | Ahmed M. | +50 | 12/05/2025 |
| 2 | Sara K. | +50 | 08/05/2025 |
| 3 | Omar H. | +50 | 01/04/2025 |
| 4 | Laila G. | +50 | 15/03/2025 |

### Referral Code
- Static code: **COFFEE50**

---

## 12. View Benefits Screen

**Route:** pushed as secondary from Loyalty Card link  
**File:** `features/account/presentation/screens/view_benefits_screen.dart`

### Layout (top → bottom)

| # | Section | Content |
|---|---|---|
| 1 | **Loyalty Card Image** | Full tier card with name + points text, no "View Benefits" link |
| 2 | **"Rewards" header** | Section title |
| 3 | **All Tiers** | 4 tier cards (Blue, Silver, Gold, Platinum) with benefits list |
| 4 | **"How to Earn Points" header** | Section title |
| 5 | **Earn Methods** | 4 earn method rows |

### All Tiers Benefits

| Tier | Color | Benefits |
|---|---|---|
| Blue | #0000FF | 10% Discount, Birthday Reward |
| Silver | #696E74 | 10% Discount, Birthday Reward, Priority Support |
| Gold | #FF891C | 10% Discount, Birthday Reward, Priority Support, Free Drink Monthly |
| Platinum | #707BE3 | 10% Discount, Birthday Reward, Priority Support, Free Drink Monthly, Exclusive Events |

Current tier is highlighted with thicker border + "Current" badge.

### How to Earn Points

| # | Icon | Text |
|---|---|---|
| 1 | `shopping_bag` | "Earn 1 point for every £1 spent" |
| 2 | `reviews` | "Earn 10 points for writing a review" |
| 3 | `share` | "Earn 50 points for each referral" |
| 4 | `card_giftcard` | "Earn 100 bonus points on your birthday" |

---

## 13. Cart Screen

**Route:** pushed as secondary from AppBar cart icon  
**File:** `features/checkout/presentation/screens/cart_screen.dart`  
**State:** `CartCubit`

### Layout (top → bottom)

| # | Section | Content |
|---|---|---|
| 1 | **Header** | "Your Bag" (36px) + "Review your curated selection." |
| 2 | **Cart Items** | List of `CartItemCard` widgets |
| 3 | **Order Summary** | Special instructions field + subtotal/shipping/total + "Proceed to Checkout" button |

### Empty State
- Large cart icon (64px)
- Text: "Your bag is empty"

### Each Cart Item Card

| Element | Details |
|---|---|
| Image | Product image (96×120) |
| Name | Product name (24px) |
| Variant text | e.g. "Whole Milk · Medium" |
| Unit price | e.g. "$7.25" (18px, primary color) |
| Close button | Removes item from cart |
| Quantity adjuster | − / count / + styled row with rounded border |

### Order Summary Card

| Element | Details |
|---|---|
| Special Instructions | "Special Instructions" header + multiline text field ("Add a note to your order...") |
| Subtotal | e.g. "$14.50" |
| Shipping | "Calculated next step" |
| Total | e.g. "$14.50" (30px, primary color) |
| CTA Button | "Proceed to Checkout" filled button → pushes `PaymentScreen` |

### States
- `CartLoading` → centered spinner
- `CartError` → error text
- `CartLoaded` → full cart UI
- `CartActionInProgress` → UI shown with action in progress
- Empty cart → empty state message

---

## 14. Payment Screen

**Route:** pushed as secondary from Cart  
**File:** `features/checkout/presentation/screens/payment_screen.dart`

### Layout (top → bottom)

| # | Section | Content |
|---|---|---|
| 1 | **Header** | "Complete Order" (36px) + "Secure checkout" |
| 2 | **Order Summary** | Two order lines with item icons + total |
| 3 | **Payment Method Selector** | 4 payment options |
| 4 | **Confirm Button** | Fixed bottom bar with gradient fade |

### PaymentOrderSummary

| # | Icon | Name | Detail | Price |
|---|---|---|---|---|
| 1 | `coffee` | Ethiopian Yirgacheffe | "Pour over, Light roast" | $8.00 |
| 2 | `bakery_dining` | Almond Croissant | "Warmed" | $6.50 |
| **Total** | | | | **$14.50** |

### Payment Method Selector (4 options)

| # | Icon | Label | Type | Action |
|---|---|---|---|---|
| 1 | `star` | "Use Points First" | Checkbox (toggle) | Toggle points usage |
| 2 | `payments` | "Credit Card" | Radio | Opens `CreditCardSheet` bottom sheet |
| 3 | `account_balance_wallet` | "Wallets" | Radio | Opens `WalletSheet` bottom sheet |
| 4 | `contactless` | "Apple Pay" | Radio | Selects Apple Pay |

### Bottom Confirm Bar
- Filled button: "CONFIRM ORDER" with `check_circle` icon
- Gradient fade overlay from transparent to surface color
- → pushes `OrderConfirmationScreen` and clears back stack

### CreditCardSheet (bottom sheet)
- Handle bar + "Saved Cards" title
- 2 saved cards: •••• 4242 (Expires 12/28), •••• 8371 (Expires 06/27)
- `AddCardForm` — Card Number, Expiry / CVV row, Name on Card, "Save Card" button

### WalletSheet (bottom sheet)
- Handle bar + "Phone number for wallet" title
- Phone number text field
- "Continue" filled button

### AddCardForm fields
- Card Number (number keyboard, credit card icon)
- Expiry + CVV side-by-side
- Name on Card (person icon)
- "Save Card" button

---

## 15. Order Confirmation Screen

**Route:** pushed as secondary from Payment (clears back stack)  
**File:** `features/checkout/presentation/screens/order_confirmation_screen.dart`

### Layout (top → bottom)

| # | Section | Content |
|---|---|---|
| 1 | **Success Icon** | `check_circle` icon (72px, primary color) |
| 2 | **Title** | "Order Complete!" (28px bold) |
| 3 | **Subtitle** | "Your order has been placed successfully." |
| 4 | **Receipt Card** | Bordered container with receipt details |

### Receipt Card Content

| Label | Value |
|---|---|
| **"Receipt"** (header) | |
| "Order Number" | `#ORD-{timestamp}` (e.g. #ORD-1234567) |
| "Date" | e.g. "22/6/2026" |
| Ethiopian Yirgacheffe | $8.00 |
| Almond Croissant | $6.50 |
| **"Total"** (bold) | **$14.50** |
| "Payment Method" | "Credit Card" |

---

## 16. Customization Screen

**Route:** pushed as secondary from menu/favorites/quick-add  
**File:** `features/customization/presentation/screens/customization_screen.dart`

### Layout (top → bottom)

| # | Section | Content |
|---|---|---|
| 1 | **Hero Image** | 30vh image (`customization_hero_image.png`) with gradient overlay + drink name + description |
| 2 | **The Base (Option Group)** | "The Base" + "Required" label + 3 option circles |
| 3 | **Sweetness (Slider)** | "Sweetness" slider (5 steps: None → Heavy) |
| 4 | **Espresso Intensity (Slider)** | "Espresso Intensity" slider (4 steps: Single → Quad) |
| 5 | **Curated Additions** | "Curated Additions" header + 4 addition cards |
| 6 | **Bottom Action Bar** | Fixed bottom bar |

### Hero Section
- Title: "Iced Oat Cortado" (36px)
- Description: "A meticulous blend of our house espresso, cut with chilled oat milk."
- Gradient overlay: transparent → `#18120D`

### The Base — 3 Options

| # | Name | Price Label | Icon |
|---|---|---|---|
| 1 | Oat | "+ $1.00" | `eco` |
| 2 | Almond | "+ $1.00" | `spa` |
| 3 | Whole | "Included" | `water_drop` |

### Sweetness Slider (5 steps)
None → Light → Standard → Extra → Heavy  
Default: Standard (index 2)

### Espresso Intensity Slider (4 steps)
Single → Double → Triple → Quad  
Default: Double (index 1)

### Curated Additions (4 items, toggleable)

| # | Name | Price | Icon |
|---|---|---|---|
| 1 | Vanilla Bean Dust | + $0.50 | `grain` |
| 2 | Lavender Syrup | + $0.75 | `local_florist` |
| 3 | Honey Drizzle | + $0.50 | `emoji_nature` |
| 4 | Cinnamon Dust | + $0.25 | `scatter_plot` |

### Bottom Action Bar

| Element | Details |
|---|---|
| Total Estimate label | "Total Estimate" |
| Total amount | "$6.50" (30px) |
| Favorite button | Heart outline circle button |
| Complete Order button | Filled button "Complete Order" with check icon → pushes `PaymentScreen` |

---

## 17. Orders Screen

**Route:** pushed as secondary from Account "Order History"  
**File:** `features/orders/presentation/screens/orders_screen.dart`  
**State:** `OrdersCubit`

### Layout

| Element | Content |
|---|---|
| Title | "Your Orders" (24px) |

### Each Order Card

| Element | Details |
|---|---|
| Date | e.g. "22 Jun 2026" (secondary color) |
| Order number | "Order #123" |
| Total | e.g. "$14.50" (primary color) |
| Status badge | e.g. "Completed" in container |
| Items | List of `OrderItemRow` (coffee icon + name + price × quantity) |
| Receipt button | `receipt` icon + "Receipt" |
| Reorder button | `replay` icon + "Reorder" |

### Each Order Item Row
- Icon: `coffee` (40px container)
- Name + price below
- Quantity: "×1"

### States
- `OrdersLoading` → spinner
- `OrdersError` → error message
- `OrdersLoaded` (empty) → "No orders" message
- `OrdersLoaded` (with items) → order list

---

## 18. Settings Screen

**Route:** pushed as secondary from Account tab gear icon  
**File:** `features/settings/presentation/screens/settings_screen.dart`  
**State:** `SettingsCubit`

### Layout (top → bottom)

| # | Section | Content |
|---|---|---|
| 1 | **"Preferences" header** | Section header label |
| 2 | **Preferences Group** | 3 settings rows in bordered container |

### Preferences Group

| # | Icon | Title | Subtitle | Trailing |
|---|---|---|---|---|
| 1 | `palette` | "Appearance" | "Dark mode" / "Light mode" | Toggle Switch |
| 2 | `language` | "Language" | "English (US)" / "العربية" | Chevron → `LanguagePickerSheet` |
| 3 | `notifications` | "Notifications" | "On" / "Off" | Toggle Switch |

| # | Section | Content |
|---|---|---|
| 3 | **"Support" header** | Section header label |
| 4 | **Support Group** | 1 settings row in bordered container |

### Support Group

| # | Icon | Title | Subtitle |
|---|---|---|---|
| 1 | `info` | "About Coffee Shop" | "Coffee Shop v1.0.0" |

### Language Picker Sheet (Bottom Sheet)
- Title: "Language"
- Two options: "English" and "العربية"
- Selected language has check icon + highlighted background
- Changes both `SettingsCubit.locale` and `EasyLocalization` locale

---

## 19. Bottom Navigation Bar

**File:** `core/widgets/app_bottom_nav_bar.dart`  
**Visible on:** All 4 tabs (hidden when secondary screen is open)

### Tabs (4)

| Index | Icon | Label | Route |
|---|---|---|---|
| 0 | `home` | "Home" | HomeScreen |
| 1 | `coffee` | "Menu" | MenuScreen |
| 2 | `favorite` | "Favorite" | FavoritesScreen |
| 3 | `person` | "Account" | AccountScreen |

When a secondary screen is open, `currentIndex` is set to `-1` (no tab highlighted).

### Style
- Glassmorphic: `BackdropFilter` blur (12px) + semi-transparent surface
- Active item: primary color background tint + rounded container

---

## 20. App Bar

**File:** `core/widgets/app_app_bar.dart`

### Content
| Position | Element |
|---|---|
| Center | App name: "Coffee Shop" |
| Leading | Back arrow (only when secondary screen is open, except OrderConfirmation) |
| Right actions | Settings gear (only on Account tab, no secondary open) |
| Right actions | Cart icon (only when no secondary is open) |

---

## 21. Quick Add Overlay (Reusable Bottom Sheet)

**File:** `core/widgets/quick_add_overlay.dart`  
**Triggered from:** Menu product items, Featured items, Favorite items, Home cards

### Layout

| # | Section | Content |
|---|---|---|
| 1 | Handle bar | 48px × 4px drag handle |
| 2 | "Saved Orders" header | Title |
| 3 | **Saved Order card** | Product image (96×96) + name + description + cart button |
| 4 | "Quick Add" header | Title |
| 5 | **Option chips** | Wrap of quick-add option chips + cart circle button |
| 6 | **Customize button** | Full-width filled button "Customize" → pushes `CustomizationScreen` |

### Quick Add Options (4 chips)

| # | Label |
|---|---|
| 1 | "Default" |
| 2 | "Double Shot" |
| 3 | "Oat Milk" |
| 4 | "Honey" |

---

## Shared Reusable Components

### AppTextField
- Optional label above
- Hint text
- Obscured text support (password toggle)
- Prefix icon + suffix icon
- Filled surface background
- Outline border (outlineVariant, focused: primary)

### AppButton
- Full-width (56px height)
- Primary style: filled with primary color
- Secondary style: outlined
- Loading state: spinner inside

### AppDropdown
- Styled dropdown with hint
- Filled surface background
- Outline border
- Items support translation via `.tr()`

### GenderSelection
- Row: "GENDER" label + Male + Female radio options

### SocialButton
- 56×56 square with outline border
- Icon centered inside

### AuthHeader
- App name + spacing + title + subtitle

### SavedCardTile
- Credit card icon + masked number + expiry + Default badge (optional) + radio/check icon

### AddCardForm
- Card Number + Expiry/CVV row + Name on Card + Save button

### CoffeeBeanIcon
- Small coffee bean silhouette icon

---

## Image Assets Used

| Asset Path | Used In |
|---|---|
| `assets/images/male_placeholder.png` | Account, EditProfile, Home (avatar), Register (default) |
| `assets/images/female_placeholder.png` | Register (when female selected) |
| `assets/images/account_card.png` | LoyaltyCardImage (card background) |
| `assets/images/coffee_preparation.png` | Menu (Yirgacheffe), Home (last order), Products |
| `assets/images/latte_art_being_poured.png` | Menu (lattes) |
| `assets/images/artisanal_coffee_brewing.png` | Menu (Desert Midnight), PromoBanner |
| `assets/images/cardamom_cose_latte.png` | FeaturedItemCard |
| `assets/menu_images/customization_hero_image.png` | CustomizationScreen hero |
| `assets/menu_images/reserve_roasts.png` | Menu category chip |
| `assets/menu_images/cold_brew.png` | Menu category chip |
| `assets/menu_images/signature_lattes.png` | Menu category chip |
| `assets/menu_images/pastries.png` | Menu category chip |

---

## App Configuration

| Setting | Value |
|---|---|
| App Name | "Coffee Shop" |
| Supported locales | English (en), Arabic (ar) |
| Default locale | English (en) |
| Default theme mode | Dark |
| Data source | Mock (configurable to real API) |

---

## State Management Summary

| Feature | Cubit | States |
|---|---|---|
| Onboarding | `OnboardingCubit` | Loading, Error, Loaded |
| Auth | `AuthCubit` | Initial, Loading, Authenticated, Error |
| Shell/Navigation | `ShellCubit` | TabIndex + SecondaryRoute stack |
| Menu | `MenuCubit` | Loading, Error, Loaded (products + categories + selectedId) |
| Cart | `CartCubit` | Loading, Error, Loaded, ActionInProgress, OrderPlaced |
| Orders | `OrdersCubit` | Loading, Error, Loaded |
| Favorites | `FavoritesCubit` | Loading, Error, Loaded |
| Profile | `ProfileCubit` | Loading, Error, Loaded |
| Settings | `SettingsCubit` | Loaded (darkMode, locale, notifications) |
