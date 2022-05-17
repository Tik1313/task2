import 'package:emoji_flag_converter/emoji_flag_converter.dart';
import 'package:flutter/material.dart';
import 'package:task2/model/country.dart';
import 'package:task2/widgets/back.dart';

import '../notifiers/country_change_value_notifier.dart';

class CountryList extends StatefulWidget {
  final List<Country> list;
  final CountryChangeValueNotifier countryChangeValueNotifier;
  const CountryList(
      {required this.countryChangeValueNotifier, required this.list, Key? key})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _CountryListState();
}

class _CountryListState extends State<CountryList> {
  late Country selected;
  var searchText = '';
  bool b = true;

  // void search(String value) {
  //   setState(() {
  //     var searchingCountries = myCountries.where((countries) =>
  //         countries.name.toLowerCase().contains(value.toLowerCase()));
  //     // print('${searchingCountries.length} ds');
  //     print(searchingCountries.length);
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return _renderCountryBuilder();
  }

  Widget _renderCountryBuilder() {
    return Scaffold(
      body: Column(
        children: [
          const MyBackButton(),
          _renderSearch(),
          Expanded(
            child: ListView.builder(
              itemCount: widget.list.length,
              itemBuilder: (context, index) {
                var country = widget.list[index];
                return country.name
                        .toLowerCase()
                        .contains(searchText.toString().toLowerCase())
                    ? Container(
                        decoration: const BoxDecoration(
                            border: Border(
                                bottom:
                                    BorderSide(width: 1, color: Colors.black))),
                        margin: const EdgeInsets.symmetric(
                            horizontal: 5, vertical: 0),
                        padding: const EdgeInsets.all(8),
                        child: TextButton(
                          onPressed: () {
                            // Provider.of<CountryChangeNotifier>(context,
                            //         listen: false)
                            //     .selectCountry(country);
                            widget.countryChangeValueNotifier
                                .selectedCountry(country);
                            // widget.finishSelection?.call(country);

                            Navigator.pop(context);
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(children: [
                                Text(EmojiConverter.fromAlpha2CountryCode(
                                    country.iso2_cc)),
                                Text(country.name),
                              ]),
                              Text('+${country.e164_cc}')
                            ],
                          ),
                        ),
                      )
                    : Container();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _renderSearch() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: TextField(
        decoration: const InputDecoration(
          hintText: 'Serach',
          prefixIcon: Icon(Icons.search),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(20))),
        ),
        onChanged: (value) {
          setState(() {
            searchText = value;
          });
        },
      ),
    );
  }
}
