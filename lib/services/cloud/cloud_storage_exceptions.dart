class CloudStorageException implements Exception {
  const CloudStorageException();
}

// C in CRUD
class CouldNotCreateEntryException extends CloudStorageException {}

// R in CRUD
class CouldNotGetAllEntriesException extends CloudStorageException {}

// U in CRUD
class CouldNotUpdateEntryException extends CloudStorageException {}

// D in CRUD
class CouldNotDeleteEntryException extends CloudStorageException {}
