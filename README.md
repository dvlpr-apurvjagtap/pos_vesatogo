# VesatoGo POS - Restaurant Point of Sale System

A modern, offline-first Point of Sale (POS) system built with Flutter for restaurants and cafes. This app provides a complete ordering workflow from product selection to payment processing and order management.

## 📹 App Demo

https://github.com/dvlpr-apurvjagtap/pos_vesatogo/tree/main/assets/demo/assignment.mp4



## Project Structure

```
lib/
├── core/                           # Core utilities and configurations
│   ├── constants/
│   │   └── app_colors.dart        # App color scheme
│   ├── database/
│   │   └── database_service.dart  # Hive database initialization
│   └── theme/
|       |--- app_theme.dart        # Themes
│       └── theme_controller.dart  # Theme management (light/dark)
│
├── shared/                        # Shared enums and utilities
│   └── enums/
│       ├── payment_method.dart    # Payment method types
│       ├── order_status.dart      # Order status states
│       └── order_type.dart        # Order types (dine-in, takeaway, delivery)
│
├── features/pos/                  # Main POS feature module
│   ├── data/                      # Data layer
│   │   ├── models/                # Data models
│   │   │   ├── product.dart       # Product model with Hive annotations
│   │   │   ├── customer.dart      # Customer model
│   │   │   ├── order.dart         # Order model
│   │   │   ├── order_item.dart    # Order item model
│   │   │   └── cart_item.dart     # Cart item model
│   │   └── data_sources/          # Data access layer
│   │       ├── product_local_source.dart  # Product CRUD operations
│   │       └── order_local_source.dart    # Order CRUD operations
│   │
│   ├── providers/                 # State management
│   │   ├── cart_provider.dart     # Shopping cart state
│   │   ├── product_provider.dart  # Product catalog state
│   │   └── order_provider.dart    # Order management state
│   │
│   └── presentation/              # UI layer
│       ├── screens/
│       │   └── pos_screen.dart    # Main POS screen
│       ├── widgets/               # Reusable widgets
│       │   ├── cart_sidebar.dart  # Shopping cart sidebar
│       │   ├── product_grid.dart  # Product display grid
│       │   ├── product_card.dart  # Individual product card
│       │   └── category_filter.dart # Category filter tabs
│       └── dialogs/               # Modal dialogs
│           ├── add_customer_dialog.dart    # Customer form dialog
│           ├── payment_dialog.dart         # Payment processing dialog
│           └── running_orders_dialog.dart  # Order management dialog
│
└── main.dart                     
```

## 🛠️ Tech Stack

### **Frontend Framework**
- **Flutter 3.x** - Cross-platform UI framework
- **Dart 3.x** - Programming language

### **State Management**
- **Provider 6.x** - Simple and scalable state management
- **ChangeNotifier** - Built-in state management pattern

### **Local Database**
- **Hive 2.x** - Fast, lightweight NoSQL database
- **Hive Generator** - Code generation for type adapters
- **Build Runner** - Build system for code generation

### **Architecture**
- **Feature-first Architecture** - Organized by business features
- **Provider Pattern** - Centralized state management

### **UI/UX**
- **Material Design 3** - Modern material design system
- **Custom Theme** - Orange-based color scheme


##  Getting Started

### Prerequisites

- **Flutter SDK** (≥ 3.0.0)
- **Dart SDK** (≥ 3.0.0)
- **Android Studio** or **VS Code** with Flutter extensions
- **Git**

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/dvlpr-apurvjagtap/pos_vesatogo.git
   cd pos_vesatogo
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Generate Hive adapters**
   ```bash
   dart run build_runner build
   ```

4. **Run the app**
   ```bash
   flutter run
   ```

### Development Setup

**For development with hot reload:**
   ```bash
   flutter run -d chrome --web-port=8080
   ```


## 📱 How to Use

### 1. **Taking Orders**
- Browse products by category or search by name
- Click on items to add them to cart
- Adjust quantities using +/- buttons
- Cart sidebar automatically opens when items are added

### 2. **Customer Management**
- Click "+ Customer" to add customer details
- Fill in mobile number (required) and other optional fields
- Edit or remove customer information as needed

### 3. **Payment Processing**
- Click "Checkout" from cart sidebar
- Review order summary and totals
- Select payment method (Cash, Card, UPI, etc.)
- Add discount or tip if applicable
- Click "Pay" to complete the transaction

### 4. **Order Management**
- View all running orders in the "Orders" dialog
- Track order status and update as needed
- Switch between "Running" and "Completed" tabs
- Use yesterday toggle to view historical orders

## 🎯 Key Features Explained

### **Offline-First Architecture**
- All data stored locally using Hive database
- No internet connection required for basic operations
- Fast data access and real-time updates

### **Smart Cart Management**
- Real-time price calculations with tax (5%)
- Quantity controls with validation
- Automatic cart clearing after successful payment
- Support for discounts and tips

### **Advanced Order Tracking**
- Order status workflow: Created → Preparing → Ready → Completed
- Token number generation for kitchen management
- Real-time order updates with timestamps
- Historical order viewing

### **Customer Relationship Management**
- Customer data persistence across sessions
- Form validation with error handling
- Optional customer information (can order without customer)
- Customer editing capabilities

## Challenges Faced & Solutions

### **1. State Management Complexity**
**Challenge:** Managing complex state across multiple screens with real-time updates.

### **2. Local Database Integration**
**Challenge:** Setting up type-safe local storage with complex relationships.

### **3. Cart Management Logic**
**Challenge:** Handling cart operations (add, remove, update quantities) with price calculations.

### **4. Dialog Navigation**
**Challenge:** Managing multiple overlapping dialogs and navigation context.

### **5. Code Generation Setup**
**Challenge:** Setting up Hive code generation for type adapters.



**This project demonstrates professional Flutter development practices and could serve as a foundation for a real-world POS system.**