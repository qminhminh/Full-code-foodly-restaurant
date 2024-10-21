import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:foodly_restaurant/common/app_style.dart';
import 'package:foodly_restaurant/common/custom_btn.dart';
import 'package:foodly_restaurant/common/reusable_text.dart';
import 'package:foodly_restaurant/constants/constants.dart';
import 'package:foodly_restaurant/controllers/Image_upload_controller.dart';
import 'package:foodly_restaurant/controllers/foods_controller.dart';
import 'package:foodly_restaurant/models/foods.dart';
import 'package:foodly_restaurant/models/foods_request.dart';
import 'package:get/get.dart';

class EditFoodPage extends StatefulWidget {
  const EditFoodPage({super.key, required this.food});

  final Food food;

  @override
  State<EditFoodPage> createState() => _EditFoodPageState();
}

class _EditFoodPageState extends State<EditFoodPage> {
  final PageController _pageController = PageController();
  late FoodsController foodController;
  late ImageUploadController imageUploader;
  final _formKey = GlobalKey<FormState>();

  late String title;
  late String description;
  late double price;
  late String time;
  List<String> foodTags = [];
  List<String> foodType = [];
  List<Additive> additives = [];
  late List<String> imagesUpdate;

  @override
  void initState() {
    super.initState();
    foodController = Get.put(FoodsController());
    imageUploader = Get.put(ImageUploadController());
    title = widget.food.title;
    description = widget.food.description;
    price = widget.food.price;
    time = widget.food.time;
    foodTags = List.from(widget.food.foodTags);
    foodType = List.from(widget.food.foodType);
    additives = List.from(widget.food.additives);
    imagesUpdate = List.from(widget.food.imageUrl);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> editImage(int index) async {
    if (index < 0 || index >= 4) {
      return;
    }

    // Mở lựa chọn ảnh từ thư viện
    await imageUploader
        .pickImage('one'); // Hoặc 'two', 'three', 'four' tùy theo vị trí

    if (imageUploader.images.isNotEmpty) {
      setState(() {
        if (index < imagesUpdate.length) {
          imagesUpdate[index] =
              imageUploader.images.last; // Cập nhật URL hình ảnh
        } else {
          imagesUpdate.add(imageUploader.images
              .last); // Nếu chưa có hình ảnh tại vị trí này, thêm vào danh sách
        }
      });
    }
  }

  void saveFood() {
    if (_formKey.currentState!.validate()) {
      // Tạo đối tượng Food từ các giá trị đã nhập
      AddFoods food = AddFoods(
        title: title, // Sử dụng biến title thay vì _title.text
        foodTags: foodTags, // Sử dụng foodTags đã được cập nhật
        foodType: foodType, // Sử dụng foodType đã được cập nhật
        isAvailable: widget
            .food.isAvailable, // Chắc chắn rằng bạn đã khởi tạo isAvailable
        code: widget.food.code, // Sử dụng mã nhà hàng
        category: widget.food.category, // Sử dụng loại món ăn
        restaurant: widget.food.restaurant, // ID của nhà hàng
        description: description, // Sử dụng biến description
        time: time, // Sử dụng biến time
        price: price, // Sử dụng biến price
        additives: additives, // Sử dụng additives đã được cập nhật
        imageUrl: imagesUpdate, // Sử dụng danh sách hình ảnh đã cập nhật
      );

      // Chuyển đổi đối tượng Food thành chuỗi JSON
      String foodItem = addFoodsToJson(food);

      // Cập nhật món ăn
      foodController.updateFood(foodItem, widget.food.id);

      // Xóa các trường nhập liệu sau khi lưu
      _clearFields();

      // Quay lại sau khi lưu
      Get.back();
    }
  }

// Hàm để xóa các trường nhập liệu
  void _clearFields() {
    title = '';
    description = '';
    price = 0.0;
    time = '';
    foodTags.clear();
    foodType.clear();
    additives.clear();
    imagesUpdate.clear(); // Nếu bạn cũng muốn xóa danh sách hình ảnh
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kLightWhite,
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius:
                    const BorderRadius.only(bottomRight: Radius.circular(25)),
                child: Stack(
                  children: [
                    SizedBox(
                      height: 230.h,
                      child: PageView.builder(
                        itemCount: imagesUpdate.length,
                        controller: _pageController,
                        itemBuilder: (context, i) {
                          return GestureDetector(
                            onTap: () => editImage(
                                i), // Gọi hàm editImage khi nhấn vào hình ảnh
                            child: Container(
                              height: 230.h,
                              width: width,
                              color: kLightWhite,
                              child: CachedNetworkImage(
                                fit: BoxFit.cover,
                                imageUrl: imagesUpdate[i],
                                placeholder: (context, url) =>
                                    const CircularProgressIndicator(),
                                errorWidget: (context, url, error) =>
                                    const Icon(Icons.error),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                top: 40.h,
                left: 12,
                right: 12,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Get.back();
                      },
                      child: const Icon(
                        Ionicons.chevron_back_circle,
                        color: kPrimary,
                        size: 28,
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                bottom: 10,
                right: 15,
                child: CustomButton(
                  btnWidth: width / 2.9,
                  radius: 30,
                  color: kPrimary,
                  onTap: saveFood,
                  text: "Save Food",
                ),
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    initialValue: title,
                    decoration: const InputDecoration(labelText: "Food Title"),
                    onChanged: (value) {
                      title = value;
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a title';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 10.h),
                  TextFormField(
                    initialValue: description,
                    decoration: const InputDecoration(labelText: "Description"),
                    onChanged: (value) {
                      description = value;
                    },
                    maxLines: 3,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a description';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 10.h),
                  TextFormField(
                    initialValue: price.toString(),
                    decoration: const InputDecoration(labelText: "Price"),
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      price = double.tryParse(value) ?? price;
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a price';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 10.h),
                  TextFormField(
                    initialValue: time,
                    decoration: const InputDecoration(labelText: "Time"),
                    onChanged: (value) {
                      time = value;
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter time';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 15.h),
                  ReusableText(
                    text: "Food Tags",
                    style: appStyle(18, kDark, FontWeight.w600),
                  ),
                  SizedBox(height: 10.h),
                  Wrap(
                    spacing: 8.0,
                    children: foodTags.map((tag) {
                      return Chip(
                        label: Text(tag),
                        onDeleted: () {
                          setState(() {
                            foodTags.remove(tag);
                          });
                        },
                      );
                    }).toList(),
                  ),
                  TextFormField(
                    decoration:
                        const InputDecoration(labelText: "Add Food Tag"),
                    onFieldSubmitted: (value) {
                      setState(() {
                        foodTags.add(value);
                      });
                    },
                  ),
                  SizedBox(height: 15.h),
                  ReusableText(
                    text: "Additives and Toppings",
                    style: appStyle(18, kDark, FontWeight.w600),
                  ),
                  SizedBox(height: 10.h),
                  Wrap(
                    spacing: 8.0,
                    children: additives.map((additive) {
                      return Chip(
                        label: Text('${additive.title} - \$${additive.price}'),
                        onDeleted: () {
                          setState(() {
                            additives.remove(additive);
                          });
                        },
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 15.h),
                  ReusableText(
                    text: "Food Type",
                    style: appStyle(18, kDark, FontWeight.w600),
                  ),
                  SizedBox(height: 10.h),
                  Wrap(
                    spacing: 8.0,
                    children: foodType.map((type) {
                      return Chip(
                        label: Text(type),
                        onDeleted: () {
                          setState(() {
                            foodType.remove(type);
                          });
                        },
                      );
                    }).toList(),
                  ),
                  TextFormField(
                    decoration:
                        const InputDecoration(labelText: "Add Food Type"),
                    onFieldSubmitted: (value) {
                      setState(() {
                        foodType.add(value);
                      });
                    },
                  ),
                  SizedBox(height: 40.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.h),
                    child: CustomButton(
                      text: "D E L E T E",
                      onTap: () {
                        // Xử lý xóa thực thể món ăn
                      },
                      color: kRed,
                      btnHieght: 35,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
