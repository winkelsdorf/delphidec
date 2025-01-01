{*****************************************************************************
  The DEC team (see file NOTICE.txt) licenses this file
  to you under the Apache License, Version 2.0 (the
  "License"); you may not use this file except in compliance
  with the License. A copy of this licence is found in the root directory
  of this project in the file LICENCE.txt or alternatively at

    http://www.apache.org/licenses/LICENSE-2.0

  Unless required by applicable law or agreed to in writing,
  software distributed under the License is distributed on an
  "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
  KIND, either express or implied.  See the License for the
  specific language governing permissions and limitations
  under the License.
*****************************************************************************}
unit DECCipherPaddings;
{$INCLUDE DECOptions.inc}

interface

uses
  {$IFDEF FPC}
  SysUtils,
  {$ELSE}
  System.SysUtils,
  {$ENDIF}
  DECTypes;

type
  /// <summary>
  ///   Base class for implementing block padding algorithms.
  /// </summary>
  /// <remarks>
  ///   Padding algorithms are used to fill data to a specific block size when the
  ///   data length is not an integer multiple of the block size.
  ///   This abstract class defines the basic interfaces for adding, validating,
  ///   and removing padding.
  /// </remarks>
  TPadding = class abstract
    /// <summary>
    ///   Adds padding to the specified data to align it with the given block size.
    /// </summary>
    /// <param name="Data">
    ///   The data to be padded.
    /// </param>
    /// <param name="BlockSize">
    ///   The block size to align the data with.
    /// </param>
    /// <returns>
    ///   The padded data.
    /// </returns>
    /// <remarks>
    ///   The specific method of padding depends on the implementation of the subclass.
    /// </remarks>
    class function AddPadding(const Data : TBytes;
                              BlockSize  : Integer): TBytes; overload; virtual; abstract;

    // <summary>
    ///   Adds PKCS#7 padding to a string.
    /// </summary>
    /// <param name="data">
    ///   The string to which padding should be added.
    /// </param>
    /// <param name="BlockSize">
    ///   The block size in byte to align the data with.
    /// </param>
    /// <returns>
    ///   A new byte string with PKCS#7 padding applied.
    /// </returns>
    /// <remarks>
    ///   PKCS#7 padding, as defined in RFC 5652 (which updates RFC 2315), adds
    ///   bytes to the end of the data so that the total length is a multiple of
    ///   the block size. Each padding byte contains the number of padding bytes
    ///   added. For example, if 5 bytes of padding are needed, each of the 5
    ///   padding bytes will have the value $5.
    /// <para>
    ///   Call this method before starting encryption.
    //  </para>
    /// </remarks>
    class function AddPadding(const Data : string;
                              BlockSize  : Integer): string; overload; virtual; abstract;
    // <summary>
    ///   Adds PKCS#7 padding to a raw byte string.
    /// </summary>
    /// <param name="data">
    ///   The raw byte string to which padding should be added.
    /// </param>
    /// <param name="BlockSize">
    ///   The block size in byte to align the data with.
    /// </param>
    /// <returns>
    ///   A new byte raw byte string with PKCS#7 padding applied.
    /// </returns>
    /// <remarks>
    ///   PKCS#7 padding, as defined in RFC 5652 (which updates RFC 2315), adds
    ///   bytes to the end of the data so that the total length is a multiple of
    ///   the block size. Each padding byte contains the number of padding bytes
    ///   added. For example, if 5 bytes of padding are needed, each of the 5
    ///   padding bytes will have the value $5.
    /// <para>
    ///   Call this method before starting encryption.
    /// </para>
    /// </remarks>
    class function AddPadding(const Data : RawByteString;
                              BlockSize  : Integer): RawByteString; overload; virtual; abstract;
    /// <summary>
    ///   Checks if the specified data contains valid padding.
    /// </summary>
    /// <param name="Data">
    ///   The data to be checked.
    /// </param>
    /// <param name="BlockSize">
    ///   The expected block size.
    /// </param>
    /// <returns>
    ///   True if the padding is valid; otherwise, False.
    /// </returns>
    /// <remarks>
    ///   This method is used to ensure the integrity and consistency of the padding.
    /// </remarks>
    class function HasValidPadding(const Data : TBytes;
                                   BlockSize  : Integer): Boolean; virtual; abstract;
    /// <summary>
    ///   Removes padding from the specified data.
    /// </summary>
    /// <param name="Data">
    ///   The data from which padding will be removed.
    /// </param>
    /// <param name="BlockSize">
    ///   The block size in bytes used for padding.
    /// </param>
    /// <returns>
    ///   The original data without padding.
    /// </returns>
    /// <remarks>
    ///   This method assumes that the padding has already been validated.
    /// </remarks>
    class function RemovePadding(const Data : TBytes;
                                 BlockSize  : Integer): TBytes; overload; virtual; abstract;
    // <summary>
    ///   Removes PKCS#7 padding from a raw byte string.
    /// </summary>
    /// <param name="data">
    ///   The padded byte raw byte string.
    /// </param>
    /// <param name="BlockSize">
    ///   The block size in bytes used for padding.
    /// </param>
    /// <returns>
    ///   A new raw byte string with the padding removed. Raises an exception
    ///   if the padding is invalid.
    /// </returns>
    /// <exception cref="EDECCipherException">
    ///   Raised if the padding is invalid or missing.
    /// </exception>
    /// <remarks>
    ///   This function checks for valid PKCS#7 padding and raises an
    ///   `EDECCipherException` exception if the padding is incorrect. This
    ///   includes cases where the final bytes do not match the pad count or if
    ///   the pad count is greater than the block size.
    ///   <para>
    ///     Call this method after decryption.
    ///   </para>
    /// </remarks>
    class function RemovePadding(const Data : RawByteString;
                                 BlockSize  : Integer): RawByteString; overload; virtual; abstract;
    // <summary>
    ///   Removes PKCS#7 padding from a string.
    /// </summary>
    /// <param name="data">
    ///   The padded byte raw byte string.
    /// </param>
    /// <param name="BlockSize">
    ///   The block size in bytes used for padding.
    /// </param>
    /// <returns>
    ///   A new raw byte string with the padding removed. Raises an exception
    ///   if the padding is invalid.
    /// </returns>
    /// <exception cref="EDECCipherException">
    ///   Raised if the padding is invalid or missing.
    /// </exception>
    /// <remarks>
    ///   This function checks for valid PKCS#7 padding and raises an
    ///   `EDECCipherException` exception if the padding is incorrect. This
    ///   includes cases where the final bytes do not match the pad count or if
    ///   the pad count is greater than the block size.
    ///   <para>
    ///     Call this method after decryption.
    ///   </para>
    /// </remarks>
    class function RemovePadding(const Data : string;
                                 BlockSize  : Integer): string; overload; virtual; abstract;
  end;

  /// <summary>
  ///   Implementation of the PKCS7 padding algorithm.
  /// </summary>
  /// <remarks>
  ///   PKCS7 padding is a standard algorithm used in symmetric cryptosystems like AES.
  ///   It appends the number of padding bytes as the value of the padding itself.
  /// </remarks>
  TPKCS7Padding = class(TPadding)
    /// <summary>
    ///   Adds PKCS7 padding to the specified data.
    /// </summary>
    /// <param name="Data">
    ///   The data to be padded.
    /// </param>
    /// <param name="BlockSize">
    ///   The block size in byte to align the data with.
    /// </param>
    /// <returns>
    ///   The padded data following the PKCS7 algorithm.
    /// </returns>
    class function AddPadding(const Data: TBytes; BlockSize: Integer): TBytes; override;

    // <summary>
    ///   Adds PKCS#7 padding to a string.
    /// </summary>
    /// <param name="data">
    ///   The string to which padding should be added.
    /// </param>
    /// <param name="BlockSize">
    ///   The block size in byte to align the data with.
    /// </param>
    /// <returns>
    ///   A new byte string with PKCS#7 padding applied.
    /// </returns>
    /// <remarks>
    ///   PKCS#7 padding, as defined in RFC 5652 (which updates RFC 2315), adds
    ///   bytes to the end of the data so that the total length is a multiple of
    ///   the block size. Each padding byte contains the number of padding bytes
    ///   added. For example, if 5 bytes of padding are needed, each of the 5
    ///   padding bytes will have the value $5.
    /// <para>
    ///   Call this method before starting encryption.
    //  </para>
    /// </remarks>
    class function AddPadding(const Data: string; BlockSize: Integer): string; override;
    // <summary>
    ///   Adds PKCS#7 padding to a raw byte string.
    /// </summary>
    /// <param name="data">
    ///   The raw byte string to which padding should be added.
    /// </param>
    /// <param name="BlockSize">
    ///   The block size in byte to align the data with.
    /// </param>
    /// <returns>
    ///   A new byte raw byte string with PKCS#7 padding applied.
    /// </returns>
    /// <remarks>
    ///   PKCS#7 padding, as defined in RFC 5652 (which updates RFC 2315), adds
    ///   bytes to the end of the data so that the total length is a multiple of
    ///   the block size. Each padding byte contains the number of padding bytes
    ///   added. For example, if 5 bytes of padding are needed, each of the 5
    ///   padding bytes will have the value $5.
    /// <para>
    ///   Call this method before starting encryption.
    /// </para>
    /// </remarks>
    class function AddPadding(const Data : RawByteString;
                              BlockSize  : Integer): RawByteString; override;

    /// <summary>
    ///   Validates if the specified data contains valid PKCS7 padding.
    /// </summary>
    /// <param name="Data">
    ///   The data to be checked.
    /// </param>
    /// <param name="BlockSize">
    ///   The expected block size.
    /// </param>
    /// <returns>
    ///   True if the padding is valid; otherwise, False.
    /// </returns>
    class function HasValidPadding(const Data : TBytes;
                                   BlockSize  : Integer): Boolean; override;
    /// <summary>
    ///   Removes PKCS7 padding from the specified data.
    /// </summary>
    /// <param name="Data">
    ///   The data from which padding will be removed.
    /// </param>
    /// <param name="BlockSize">
    ///   The block size used for padding.
    /// </param>
    /// <exception cref="EDECCipherException">
    ///   Raised if the padding is invalid or missing.
    /// </exception>
    /// <returns>
    ///   The original data without padding.
    /// </returns>
    class function RemovePadding(const Data : TBytes;
                                 BlockSize  : Integer): TBytes; override;
    // <summary>
    ///   Removes PKCS#7 padding from a raw byte string.
    /// </summary>
    /// <param name="data">
    ///   The padded byte raw byte string.
    /// </param>
    /// <param name="BlockSize">
    ///   The block size in bytes used for padding.
    /// </param>
    /// <returns>
    ///   A new raw byte string with the padding removed. Raises an exception
    ///   if the padding is invalid.
    /// </returns>
    /// <exception cref="EDECCipherException">
    ///   Raised if the padding is invalid or missing.
    /// </exception>
    /// <remarks>
    ///   This function checks for valid PKCS#7 padding and raises an
    ///   `EDECCipherException` exception if the padding is incorrect. This
    ///   includes cases where the final bytes do not match the pad count or if
    ///   the pad count is greater than the block size.
    ///   <para>
    ///     Call this method after decryption.
    ///   </para>
    /// </remarks>
    class function RemovePadding(const Data : RawByteString;
                                 BlockSize  : Integer): RawByteString; override;
    // <summary>
    ///   Removes PKCS#7 padding from a string.
    /// </summary>
    /// <param name="data">
    ///   The padded byte raw byte string.
    /// </param>
    /// <param name="BlockSize">
    ///   The block size in bytes used for padding.
    /// </param>
    /// <returns>
    ///   A new raw byte string with the padding removed. Raises an exception
    ///   if the padding is invalid.
    /// </returns>
    /// <exception cref="EDECCipherException">
    ///   Raised if the padding is invalid or missing.
    /// </exception>
    /// <remarks>
    ///   This function checks for valid PKCS#7 padding and raises an
    ///   `EDECCipherException` exception if the padding is incorrect. This
    ///   includes cases where the final bytes do not match the pad count or if
    ///   the pad count is greater than the block size.
    ///   <para>
    ///     Call this method after decryption.
    ///   </para>
    /// </remarks>
    class function RemovePadding(const Data : string;
                                 BlockSize  : Integer): string; override;
  end;

implementation

uses
  DECUtil;

{ TPKCS7Padding }

class function TPKCS7Padding.AddPadding(const Data: TBytes; BlockSize: Integer): TBytes;
var
  PadLength: Integer;
  PadByte: Byte;
  I: Integer;
begin
  PadLength := BlockSize - (Length(Data) mod BlockSize);
  SetLength(Result, Length(Data) + PadLength);
  if Length(Data) > 0 then
    Move(Data[0], Result[0], Length(Data));
  PadByte := Byte(PadLength);
  for I := Length(Data) to High(Result) do
    Result[I] := PadByte;
end;

class function TPKCS7Padding.AddPadding(const Data: string; BlockSize: Integer): string;
var
  Buf: TBytes;
begin
  Buf    := AddPadding(StringToBytes(Data), BlockSize);
  Result := BytesToString(Buf);
  ProtectBytes(Buf);
end;

class function TPKCS7Padding.AddPadding(const Data : RawByteString;
                                        BlockSize  : Integer): RawByteString;
var
  Buf: TBytes;
begin
  Buf    := AddPadding(RawStringToBytes(Data), BlockSize);
  Result := BytesToRawString(Buf);
  ProtectBytes(Buf);
end;

class function TPKCS7Padding.HasValidPadding(const Data: TBytes; BlockSize: integer): boolean;
var
  PadLength: Integer;
  I: Integer;
begin
  if Length(Data) = 0 then
    exit(false);
  PadLength := Data[High(Data)];
  if (PadLength <= 0) or (PadLength > BlockSize) then
    exit(false);
  for I := Length(Data) - PadLength to High(Data) do
    if Data[I] <> Byte(PadLength) then
      exit(false);
  result := true;
end;

class function TPKCS7Padding.RemovePadding(const Data : string;
                                           BlockSize  : Integer): string;
var
  Buf: TBytes;
begin
  Buf    := RemovePadding(StringToBytes(Data), BlockSize);
  Result := BytesToString(Buf);
  ProtectBytes(Buf);
end;

class function TPKCS7Padding.RemovePadding(const Data : RawByteString;
                                           BlockSize  : Integer): RawByteString;
var
  Buf: TBytes;
begin
  Buf    := RemovePadding(RawStringToBytes(Data), BlockSize);
  Result := BytesToRawString(Buf);
  ProtectBytes(Buf);
end;

class function TPKCS7Padding.RemovePadding(const Data: TBytes; BlockSize: integer): TBytes;
var
  PadLength: Integer;
begin
  if not HasValidPadding(Data, BlockSize) then
    raise EDECCipherException.Create('Invalid PKCS#7 padding');
  PadLength := Data[High(Data)];
  SetLength(Result, Length(Data) - PadLength);
  if length(Result) > 0 then
    Move(Data[0], Result[0], Length(Result));
end;

end.
