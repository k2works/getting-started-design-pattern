// Interpreter パターン
// Scala 3 の enum（ADT）とパターンマッチで DSL を構築する

package designpattern.interpreter

import java.io.File

// 式の AST を enum で定義
enum Expression:
  case All
  case FileName(pattern: String)
  case Bigger(sizeInBytes: Long)
  case Not(expr: Expression)
  case And(left: Expression, right: Expression)
  case Or(left: Expression, right: Expression)

object Expression:
  // 評価: ファイルリストをフィルタリングする
  def evaluate(expr: Expression, files: List[FileEntry]): List[FileEntry] =
    expr match
      case All => files
      case FileName(pattern) =>
        files.filter(f => f.name.matches(pattern.replace("*", ".*")))
      case Bigger(size) =>
        files.filter(_.size > size)
      case Not(e) =>
        val matched = evaluate(e, files).toSet
        files.filterNot(matched.contains)
      case And(left, right) =>
        val leftResult = evaluate(left, files).toSet
        val rightResult = evaluate(right, files).toSet
        files.filter(f => leftResult.contains(f) && rightResult.contains(f))
      case Or(left, right) =>
        val leftResult = evaluate(left, files).toSet
        val rightResult = evaluate(right, files).toSet
        files.filter(f => leftResult.contains(f) || rightResult.contains(f))

// ファイルエントリ（テスト用にファイルシステムから独立させる）
case class FileEntry(name: String, size: Long)
