// Copyright 2018 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

//Import relevant packages
import 'dart:io';
import 'dart:convert' show json, utf8;

import 'package:task_11_api/category.dart';
import 'package:task_11_api/unit.dart';
/// The REST API retrieves unit conversions for [Categories] that change.
///
/// For example, the currency exchange rate, stock prices, the height of the
/// tides change often.
/// We have set up an API that retrieves a list of currencies and their current
/// exchange rate (mock data).
///   GET /currency: get a list of currencies
///   GET /currency/convert: get conversion from one currency amount to another
class Api {
  final httpClient = HttpClient();
  final url = 'flutter.udacity.com';

  //Create getUnits()
  /// Gets all the units and conversion rates for a given category.
  ///
  /// The `category` parameter is the name of the [Category] from which to
  /// retrieve units. We pass this into the query parameter in the API call.
  ///
  /// Returns a list. Returns null on error.
  Future<List<Unit>> getUnits(String category) async {
    final uri = Uri.http(url,'/$category');
    final httpRequest = await httpClient.getUrl(uri);
    final httpRespsonse = await httpRequest.close();
    if (httpRespsonse.statusCode != HttpStatus.ok){
      return null;
    }
    //read uft8
    final responseBody = await httpRespsonse.transform(utf8.decoder).join();
    //convert to json format
    final jsonResponse = json.decode(responseBody);
    var jsonUnits = jsonResponse['units'] as List;
    return jsonUnits.map<Unit>((json) => Unit.fromJson(json)).toList();
  }

  //Create convert()
  /// Given two units, converts from one to another.
  ///
  /// Returns a double, which is the converted amount. Returns null on error.
  Future<double> convert(String category, String amount, String from, String to) async {
    final uri = Uri.https(url, '/$category/convert',{'from':from, 'to':to, 'amount': amount});
    final httpRequest = await httpClient.getUrl(uri);
    final httpResponse = await httpRequest.close();
    if (httpResponse.statusCode != HttpStatus.ok) {
        return null;
    }
    final responseBoby = await httpResponse.transform(utf8.decoder).join();
    var jsonResponse = json.decode(responseBoby);
    return jsonResponse['conversion'].toDouble();
  }

}
