DateTime asLocalTime(DateTime dt) {
  if (dt.isUtc) return dt.toLocal();
  return dt;
}

