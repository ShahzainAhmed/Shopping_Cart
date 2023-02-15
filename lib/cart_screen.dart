import 'package:badges/badges.dart';
import 'package:flutter/material.dart' hide Badge;
import 'package:provider/provider.dart';
import 'package:shopping_cart/db_helper.dart';
import 'cart_model.dart';
import 'cart_provider.dart';

class CartScreen extends StatefulWidget {
  CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  DBHelper? dbHelper = DBHelper();
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Products"),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
        actions: [
          Center(
            child: Badge(
              badgeContent: Consumer<CartProvider>(
                builder: (context, value, child) {
                  return Text(
                    value.getCounter().toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  );
                },
              ),
              badgeAnimation: const BadgeAnimation.fade(
                animationDuration: Duration(milliseconds: 300),
              ),
              child: const Icon(
                Icons.shopping_cart_outlined,
                size: 30,
              ),
            ),
          ),
          const SizedBox(width: 20),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            FutureBuilder(
              future: cart.getData(),
              builder: (context, AsyncSnapshot<List<Cart>> snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data!.isEmpty) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: const [
                        SizedBox(
                          height: 80,
                        ),
                        Center(
                          child: Image(
                            image: AssetImage(
                              'images/empty_cart.png',
                            ),
                          ),
                        ),
                      ],
                    );
                  } else {
                    return Expanded(
                      child: ListView.builder(
                        itemCount: snapshot.data!.length,
                        itemBuilder: ((context, index) {
                          return Card(
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Image(
                                        height: 100,
                                        width: 100,
                                        image: NetworkImage(
                                          snapshot.data![index].image
                                              .toString(),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 15,
                                      ),
                                      Expanded(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  snapshot
                                                      .data![index].productName
                                                      .toString(),
                                                  style: const TextStyle(
                                                      fontSize: 23,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                                InkWell(
                                                  onTap: () {
                                                    dbHelper!.delete(snapshot
                                                        .data![index].id!);
                                                    cart.removeCounter();
                                                    cart.removeTotalPrice(
                                                      double.parse(
                                                        snapshot.data![index]
                                                            .productPrice
                                                            .toString(),
                                                      ),
                                                    );
                                                  },
                                                  child: Icon(
                                                    Icons.delete,
                                                    color: Colors.grey[700],
                                                  ),
                                                )
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 5,
                                            ),
                                            Text(
                                              snapshot.data![index].unitTag
                                                      .toString() +
                                                  " " r"$" +
                                                  snapshot
                                                      .data![index].productPrice
                                                      .toString(),
                                              style:
                                                  const TextStyle(fontSize: 22),
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            Align(
                                              alignment: Alignment.centerRight,
                                              child: InkWell(
                                                onTap: () {},
                                                child: Container(
                                                  height: 35,
                                                  width: 100,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                    color: Colors.green,
                                                  ),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            4.0),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        InkWell(
                                                          onTap: () {
                                                            int quantity =
                                                                snapshot
                                                                    .data![
                                                                        index]
                                                                    .quantity!;
                                                            int price = snapshot
                                                                .data![index]
                                                                .initialPrice!;
                                                            quantity--; // decrement
                                                            int? newPrice =
                                                                price *
                                                                    quantity;

                                                            if (quantity > 0) {
                                                              dbHelper!
                                                                  .updateQuantity(Cart(
                                                                      id: snapshot
                                                                          .data![
                                                                              index]
                                                                          .id,
                                                                      productId: snapshot
                                                                          .data![
                                                                              index]
                                                                          .id!
                                                                          .toString(),
                                                                      productName: snapshot
                                                                          .data![
                                                                              index]
                                                                          .productName,
                                                                      initialPrice: snapshot
                                                                          .data![
                                                                              index]
                                                                          .initialPrice!,
                                                                      productPrice:
                                                                          newPrice,
                                                                      quantity:
                                                                          quantity,
                                                                      unitTag: snapshot
                                                                          .data![
                                                                              index]
                                                                          .unitTag
                                                                          .toString(),
                                                                      image: snapshot
                                                                          .data![
                                                                              index]
                                                                          .image
                                                                          .toString()))
                                                                  .then(
                                                                      (value) {
                                                                newPrice = 0;
                                                                quantity = 0;
                                                                cart.removeTotalPrice(
                                                                    double.parse(snapshot
                                                                        .data![
                                                                            index]
                                                                        .initialPrice!
                                                                        .toString()));
                                                              }).onError((error,
                                                                      stackTrace) {
                                                                print(error
                                                                    .toString());
                                                              });
                                                            }
                                                          },
                                                          child: const Icon(
                                                            Icons.remove,
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                        Text(
                                                          snapshot.data![index]
                                                              .quantity
                                                              .toString(),
                                                          style:
                                                              const TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 20,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ),
                                                        ),
                                                        InkWell(
                                                          onTap: () {
                                                            int quantity =
                                                                snapshot
                                                                    .data![
                                                                        index]
                                                                    .quantity!;
                                                            int price = snapshot
                                                                .data![index]
                                                                .initialPrice!;
                                                            quantity++; // increment
                                                            int? newPrice =
                                                                price *
                                                                    quantity;

                                                            dbHelper!
                                                                .updateQuantity(Cart(
                                                                    id: snapshot
                                                                        .data![
                                                                            index]
                                                                        .id!,
                                                                    productId:
                                                                        snapshot
                                                                            .data![
                                                                                index]
                                                                            .id!
                                                                            .toString(),
                                                                    productName: snapshot
                                                                        .data![
                                                                            index]
                                                                        .productName,
                                                                    initialPrice: snapshot
                                                                        .data![
                                                                            index]
                                                                        .initialPrice!,
                                                                    productPrice:
                                                                        newPrice,
                                                                    quantity:
                                                                        quantity,
                                                                    unitTag: snapshot
                                                                        .data![
                                                                            index]
                                                                        .unitTag
                                                                        .toString(),
                                                                    image: snapshot
                                                                        .data![
                                                                            index]
                                                                        .image
                                                                        .toString()))
                                                                .then((value) {
                                                              newPrice = 0;
                                                              quantity = 0;
                                                              cart.addTotalPrice(
                                                                  double.parse(snapshot
                                                                      .data![
                                                                          index]
                                                                      .initialPrice!
                                                                      .toString()));
                                                            }).onError((error,
                                                                    stackTrace) {
                                                              print(error
                                                                  .toString());
                                                            });
                                                          },
                                                          child: const Icon(
                                                              Icons.add,
                                                              color:
                                                                  Colors.white),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ),
                          );
                        }),
                      ),
                    );
                  }
                } else {
                  return const Text("Empty Cart");
                }
              },
            ),
            Consumer<CartProvider>(builder: (context, value, child) {
              return Visibility(
                visible:
                    value.getTotalPrice().toStringAsFixed(2) == '0.00' // 0.00
                        ? false
                        : true,
                child: Column(
                  children: [
                    ReusableWidget('Sub Total',
                        r'$' + value.getTotalPrice().toStringAsFixed(2)),
                    ReusableWidget('Discount 5%', r'$' + '20'),
                    ReusableWidget('Total',
                        r'$' + value.getTotalPrice().toStringAsFixed(2)),
                  ],
                ),
              );
            })
          ],
        ),
      ),
    );
  }
}

class ReusableWidget extends StatelessWidget {
  final String title, value;
  const ReusableWidget(this.title, this.value, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            //  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            style: Theme.of(context).textTheme.titleLarge,
          ),
          Text(
            value,
            // style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            style: Theme.of(context).textTheme.titleLarge,
          )
        ],
      ),
    );
  }
}
