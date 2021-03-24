import 'package:flutter/material.dart';

class DatatableHeader {
  final String? text;
  final String? value;
  final bool? sortable;
  final bool editable;
  bool? show;
  final TextAlign? textAlign;
  final int? flex;
  final double minWidth;
  final Widget Function(dynamic value)? headerBuilder;
  final Widget Function(dynamic value, Map<String?, dynamic> row)? sourceBuilder;

  DatatableHeader({
    this.text,
    this.textAlign: TextAlign.center,
    this.sortable,
    this.value,
    this.show: true,
    this.editable: false,
    this.flex,
    this.minWidth = 0,
    this.headerBuilder,
    this.sourceBuilder,
  });

  factory DatatableHeader.fromMap(Map<String, dynamic> map) => DatatableHeader(
        text: map['text'],
        value: map['value'],
        sortable: map['sortable'],
        show: map['show'],
        textAlign: map['textAlign'],
        flex: map['flex'],
        minWidth: map['minWidth'],
        headerBuilder: map['headerBuilder'],
        sourceBuilder: map['sourceBuilder'],
      );
  Map<String, dynamic> toMap() => {
        "text": this.text,
        "value": this.value,
        "sortable": this.sortable,
        "show": this.show,
        "textAlign": this.textAlign,
        "flex": this.flex,
        "minWidth": this.minWidth,
        "headerBuilder": this.headerBuilder,
        "sourceBuilder": this.sourceBuilder,
      };
}
