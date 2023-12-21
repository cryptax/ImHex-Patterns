#include <std/io.pat>
#include <std/mem.pat>

namespace type {
    /* Dart uses a custom LEB128 type which stops when most significant bit is 1 instead of 0 */
	struct DartUnsignedBase {
        u8 array[while($ == addressof(this) || $[$-1] & 0x80 == 0)] [[hidden]];
	} [[sealed]];

	using DartUnsigned = DartUnsignedBase [[format("type::impl::format"), transform("type::impl::transform")]];
	
	namespace impl {
		fn transform_array(ref auto array) {
		  u128 x = 0;
		  u128 s = 0;
		  u128 b = 0;
		  u128 i = 0;
		  
		  while (1) {
		      b = array[i];
		      i = i+ 1;
		      if (b & 0x80) {
		          break;
		      }
		      x |= (b & 0x7f) << s;
		      s += 7;
		  }
		  x |= (b - 0x80) << s;
		  return x;
		};
		
		fn format(ref auto leb128) {
			u128 res = type::impl::transform_array(leb128.array);
			return std::format("{} ({:#x})", res, res);
		};
	
		fn transform(ref auto leb128) {
		  std::print("{}", leb128);
			return type::impl::transform_array(leb128.array);
		};
	}
	
}

struct DartString {
    u32 tag;
    u32 unknown;
    u64 doubleLength [[hidden]];
    u64 length = doubleLength / 2 [[export]];
    char content[length]; // this string is not null terminated
};

enum SnapshotKind : u64 {
    kFull = 0,      // Full snapshot of core libraries or an application.
    kFullJIT = 1,   // Full + JIT code
    kFullAOT = 2,   // Full + AOT code
    kMessage = 3,   // A partial snapshot used only for isolate messaging.
    kNone = 4,      // gen_snapshot
    kInvalid = 5
};

enum ClassId : s32 {
  kIllegalCid = 0,
  kNativePointer,
  kFreeListElement,
  kForwardingCorpse,
  kObjectCid, kClassCid, kPatchClassCid, kFunctionCid, kTypeParametersCid, kClosureDataCid, kFfiTrampolineDataCid, 
  kFieldCid, kScriptCid, kLibraryCid, kNamespaceCid, kKernelProgramInfoCid, kWeakSerializationReferenceCid, 
  kWeakArrayCid, kCodeCid, kInstructionsCid, kInstructionsSectionCid, kInstructionsTableCid, kObjectPoolCid, 
  kPcDescriptorsCid, kCodeSourceMapCid, kCompressedStackMapsCid, kLocalVarDescriptorsCid, kExceptionHandlersCid, 
  kContextCid, kContextScopeCid, kSentinelCid, kSingleTargetCacheCid, kUnlinkedCallCid, kMonomorphicSmiableCallCid, 
  kCallSiteDataCid, kICDataCid, kMegamorphicCacheCid, kSubtypeTestCacheCid, kLoadingUnitCid, kErrorCid, 
  kApiErrorCid, kLanguageErrorCid, kUnhandledExceptionCid, kUnwindErrorCid, kInstanceCid, kLibraryPrefixCid, 
  kTypeArgumentsCid, kAbstractTypeCid, kTypeCid, kFunctionTypeCid, kRecordTypeCid, kTypeParameterCid, kFinalizerBaseCid, 
  kFinalizerCid, kNativeFinalizerCid, kFinalizerEntryCid, kClosureCid, kNumberCid, kIntegerCid, kSmiCid, kMintCid, 
  kDoubleCid, kBoolCid, kFloat32x4Cid, kInt32x4Cid, kFloat64x2Cid, kRecordCid, kTypedDataBaseCid, kTypedDataCid, 
  kExternalTypedDataCid, kTypedDataViewCid, kPointerCid, kDynamicLibraryCid, kCapabilityCid, kReceivePortCid, 
  kSendPortCid, kStackTraceCid, kSuspendStateCid, kRegExpCid, kWeakPropertyCid, kWeakReferenceCid, kMirrorReferenceCid, 
  kFutureOrCid, kUserTagCid, kTransferableTypedDataCid, kMapCid, kConstMapCid, kSetCid, kConstSetCid, kArrayCid, 
  kImmutableArrayCid, kGrowableObjectArrayCid, kStringCid, kOneByteStringCid, kTwoByteStringCid, kExternalOneByteStringCid, 
  kExternalTwoByteStringCid, kFfiNativeFunctionCid, kFfiInt8Cid, kFfiInt16Cid, kFfiInt32Cid, 
  kFfiInt64Cid, kFfiUint8Cid, kFfiUint16Cid, kFfiUint32Cid, kFfiUint64Cid, kFfiFloatCid, kFfiDoubleCid, 
  kFfiVoidCid, kFfiHandleCid, kFfiBoolCid, kFfiNativeTypeCid, kFfiStructCid,
  kTypedDataInt8ArrayCid, kTypedDataInt8ArrayViewCid, kExternalTypedDataInt8ArrayCid, 
  kUnmodifiableTypedDataInt8ArrayViewCid, kTypedDataUint8ArrayCid, kTypedDataUint8ArrayViewCid, 
  kExternalTypedDataUint8ArrayCid, kUnmodifiableTypedDataUint8ArrayViewCid, kTypedDataUint8ClampedArrayCid, 
  kTypedDataUint8ClampedArrayViewCid, kExternalTypedDataUint8ClampedArrayCid, kUnmodifiableTypedDataUint8ClampedArrayViewCid, 
  kTypedDataInt16ArrayCid, kTypedDataInt16ArrayViewCid, kExternalTypedDataInt16ArrayCid, kUnmodifiableTypedDataInt16ArrayViewCid, 
  kTypedDataUint16ArrayCid, kTypedDataUint16ArrayViewCid, kExternalTypedDataUint16ArrayCid, 
  kUnmodifiableTypedDataUint16ArrayViewCid, kTypedDataInt32ArrayCid, kTypedDataInt32ArrayViewCid, 
  kExternalTypedDataInt32ArrayCid, kUnmodifiableTypedDataInt32ArrayViewCid, kTypedDataUint32ArrayCid, 
  kTypedDataUint32ArrayViewCid, kExternalTypedDataUint32ArrayCid, kUnmodifiableTypedDataUint32ArrayViewCid, 
  kTypedDataInt64ArrayCid, kTypedDataInt64ArrayViewCid, kExternalTypedDataInt64ArrayCid, 
  kUnmodifiableTypedDataInt64ArrayViewCid, kTypedDataUint64ArrayCid, kTypedDataUint64ArrayViewCid, 
  kExternalTypedDataUint64ArrayCid, kUnmodifiableTypedDataUint64ArrayViewCid, kTypedDataFloat32ArrayCid, 
  kTypedDataFloat32ArrayViewCid, kExternalTypedDataFloat32ArrayCid, kUnmodifiableTypedDataFloat32ArrayViewCid, 
  kTypedDataFloat64ArrayCid, kTypedDataFloat64ArrayViewCid, kExternalTypedDataFloat64ArrayCid, 
  kUnmodifiableTypedDataFloat64ArrayViewCid, kTypedDataFloat32x4ArrayCid, kTypedDataFloat32x4ArrayViewCid, 
  kExternalTypedDataFloat32x4ArrayCid, kUnmodifiableTypedDataFloat32x4ArrayViewCid, kTypedDataInt32x4ArrayCid, 
  kTypedDataInt32x4ArrayViewCid, kExternalTypedDataInt32x4ArrayCid, kUnmodifiableTypedDataInt32x4ArrayViewCid, 
  kTypedDataFloat64x2ArrayCid, kTypedDataFloat64x2ArrayViewCid, kExternalTypedDataFloat64x2ArrayCid, 
  kUnmodifiableTypedDataFloat64x2ArrayViewCid,
  kByteDataViewCid,
  kUnmodifiableByteDataViewCid,
  kByteBufferCid,
  kNullCid,
  kDynamicCid,
  kVoidCid,
  kNeverCid,
  kNumPredefinedCids,
};


struct ClusterInfo {
    type::DartUnsigned baseObjCount;
    type::DartUnsigned objCount;
    type::DartUnsigned clusterCount;
    type::DartUnsigned codeOrderLength;
};

struct ClusterAlloc {
    ClassId classId;
};

struct DartSnapshotHeader {
    u8 magic[4];    // F5F5DCDC
    u64 size;       // snapshot length
    SnapshotKind kind;
    u8 version_hash[32];
    char features[]; // null terminated
};


DartSnapshotHeader dartsnapshotheader_at_0x85C0 @ 0x85C0;
ClusterInfo clusterinfo_at_0x8687 @ 0x8687;


struct myunsigneds {
    type::DartUnsigned values[10000];
};


myunsigneds myunsigneds_at_0x8691 @ 0x8691;

struct DartShit {
    u32 length;
    u8 data[length >> 2];
};

struct myshit {
    DartShit values[831];
};


myshit myshit_at_0x235DC @ 0x235DC;


DartString dartstring_at_0x350D0 @ 0x350D0;
DartString dartstring_at_0x350B0 @ 0x350B0;
DartString dartstring_at_0x350F0 @ 0x350F0;
DartString dartstring_at_0x35130 @ 0x35130;
DartString dartstring_at_0x35160 @ 0x35160;
DartString dartstring_at_0x35190 @ 0x35190;
DartString dartstring_at_0x35990 @ 0x35990;
DartString dartstring_at_0x361A0 @ 0x361A0;
DartString dartstring_at_0x36260 @ 0x36260;
DartString dartstring_at_0x37D70 @ 0x37D70;
DartString dartstring_at_0x40D90 @ 0x40D90;
DartString dartstring_at_0x40DB0 @ 0x40DB0;
DartString dartstring_at_0x40DD0 @ 0x40DD0;
DartString dartstring_at_0x41160 @ 0x41160;
DartString dartstring_at_0x41B10 @ 0x41B10;
DartString dartstring_at_0x41B90 @ 0x41B90;
DartString dartstring_at_0x4D790 @ 0x4D790;
DartString dartstring_at_0x4D9D0 @ 0x4D9D0;
DartString dartstring_at_0x28B00 @ 0x28B00;
DartString dartstring_at_0x39AF0 @ 0x39AF0;