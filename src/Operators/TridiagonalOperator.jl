## This makes implementing operators simpler
# but overrided addentries! directly is likely to be faster

abstract BidiagonalOperator{T} <: BandedOperator{T}
abstract TridiagonalOperator{T} <: BandedOperator{T}
# override getdiagonalentry

bandinds(::BidiagonalOperator)=0,1
bandinds(::TridiagonalOperator)=-1,1



Base.Tridiagonal{T}(J::TridiagonalOperator{T},n::Integer)=Tridiagonal(T[J.γ(k) for k=2:n],
T[J.α(k) for k=1:n],
T[J.β(k) for k=1:n-1])


function symmetrize{T}(J::TridiagonalOperator{T},n::Integer)
    d=Array(T,n)
    d[1]=1
    for k=2:n
        d[k]=sqrt(J[k,k-1]/J[k-1,k])*d[k-1]
    end

   SymTridiagonal(
    T[J[k,k] for k=1:n],
    T[J[k,k+1]*d[k+1]/d[k] for k=1:n-1])
end
