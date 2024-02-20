#include <std/io.pat>
#include <std/mem.pat>
#include <std/ptr.pat>

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
    u64 doubleLength [[hidden]]; // the format actually shows a SMI for the length
    u64 length = doubleLength / 2 [[export]]; // Divide SMI by 2
    char content[length]; // this string is not null terminated
};

enum SnapshotKind : u64 {
    kFull = 0,      	// Full snapshot of core libraries or an application.
    kFullJIT = 1,   	// Full + JIT code
    kFullAOT = 2,   	// Full + AOT code
    kMessage = 3,   	// A partial snapshot used only for isolate messaging.
    kNone = 4,      	// gen_snapshot
    kInvalid = 5
};

enum ClassId : s32 {
  kIllegalCid = 0,  kNativePointer, kFreeListElement,  kForwardingCorpse,
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
  kUnmodifiableTypedDataFloat64x2ArrayViewCid,   kByteDataViewCid,  kUnmodifiableByteDataViewCid,  kByteBufferCid,
  kNullCid,  kDynamicCid,  kVoidCid,  kNeverCid,  kNumPredefinedCids,
};


struct ClusterInfo {
    type::DartUnsigned baseObjCount [[comment("Number of base objects")]];
    type::DartUnsigned objCount [[comment("Number of objects")]];	
    type::DartUnsigned clusterCount [[comment("Number of clusters")]];
    type::DartUnsigned codeOrderLength;	
};


struct DartSnapshotHeader {
    u8 magic[4];    // F5F5DCDC
    u64 size;       // snapshot length
    SnapshotKind kind;
    u8 version_hash[32];
    char features[]; // null terminated
};


struct OffsetToIsolate {
    DartSnapshotHeader *offset: u32 [[pointer_base("std::ptr::relative_to_pointer")]];
};

// first snapshot
DartSnapshotHeader vmsnapshot @ 0x200;

//OffsetToIsolate offset2isolate @ $ + vmsnapshot.size - 0xc6 + 16*4;
//DartSnapshotHeader isolate @ addressof(offset2isolate.offset);

DartSnapshotHeader isolatesnapshot @ 0x8740;
ClusterInfo isolate_cluster_info @ 0x8807;
DartString dartstring_at_0x29190 @ 0x29190;
DartString dartstring_at_0x291c0 @ 0x291c0;
DartString dartstring_at_0x291e0 @ 0x291e0;
DartString dartstring_at_0x280a0 @ 0x280a0;