import 'package:archapp/data/model/currency_model.dart';
import 'package:archapp/provider/home_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => HomeProvider(),
      builder: (context, child) {
        return _scaffold(context);
      },
    );
  }

  Scaffold _scaffold(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text("HomePage"),
        ),
        body: Builder(builder: (context) {
          if (context.watch<HomeProvider>().isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (context.watch<HomeProvider>().errorMessage.isNotEmpty) {
            return Center(
              child:
                  Text(context.watch<HomeProvider>().errorMessage.toString()),
            );
          } else {
            Box<CurrencyModel> data =
                context.watch<HomeProvider>().userRepository.currencyBox!;
            return RefreshIndicator(
              onRefresh: context.read<HomeProvider>().update,
              child: ListView.builder(
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(data.getAt(index)!.name.toString()),
                    subtitle: Text(data.getAt(index)!.email.toString()),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        context
                            .read<HomeProvider>()
                            .deleteUser(data.getAt(index)!.id.toString());
                      },
                    ),
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(
                          "https://source.unsplash.com/random/$index"),
                    ),
                  );
                },
                itemCount: data.length,
              ),
            );
          }
        }),
      );
}
